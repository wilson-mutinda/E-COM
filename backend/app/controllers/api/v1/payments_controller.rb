class Api::V1::PaymentsController < ApplicationController

  # create_payment
  def create_payment
    begin
      customer = Customer.find(payment_params[:customer_id])
      device = Device.find(payment_params[:device_id])

      # create_payment
      created_payment = Payment.create(
        customer: customer,
        device: device,
        status: "Pending",
        amount: device.price,
        phone: customer.user.phone
      )

      if created_payment
        # send stk_push
        mpesa = MpesaService.new
        stk_response = mpesa.stk_push(
          device.price.to_i,
          customer.user.phone,
          created_payment.id.to_s,
          "Initiated payment for #{device.name}"
        )
        # store the checkout_request_id from M-Pesa response
        if stk_response['ResponseCode'] == '0' && stk_response['CheckoutRequestID']
          created_payment.update(checkout_request_id: stk_response['CheckoutRequestID'])
          Rails.logger.info("Stored checkout_request_id: #{stk_response['CheckoutRequestID']}")
        end

        render json: { 
          message: "Initiated STK PUSH",
          response: stk_response,
          phone: customer.user.phone,
          device_name: device.name,
          device_price: device.price,
          checkout_request_id: stk_response['CheckoutRequestID']
        }, status: :ok
      else
        render json: { error: "Error Creting Payment", info: created_payment.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # mpesa_callback
  def mpesa_callback
    begin
      Rails.logger.info "=== MPESA CALLBACK STARTED ==="
      callback_data = JSON.parse(request.body.read)
      
      # Log the callback for debugging
      Rails.logger.info "MPESA CALLBACK RECEIVED: #{callback_data.inspect}"
      
      stk_callback = callback_data['Body']['stkCallback']
      result_code = stk_callback['ResultCode']
      result_desc = stk_callback['ResultDesc']
      checkout_request_id = stk_callback['CheckoutRequestID']

      Rails.logger.info "Looking for payment with checkout_request_id: #{checkout_request_id}"
      
      if result_code == 0 # Success
        # Extract payment details from metadata
        callback_metadata = stk_callback['CallbackMetadata']['Item']
        
        metadata = {}
        callback_metadata.each do |item|
          metadata[item['Name']] = item['Value']
        end
        
        mpesa_receipt = metadata['MpesaReceiptNumber']
        amount = metadata['Amount']
        phone = metadata['PhoneNumber']
        transaction_date_int = metadata['TransactionDate']
        
        # Convert M-Pesa transaction date (YYYYMMDDHHMMSS) to proper timestamp
        transaction_date = convert_mpesa_date(transaction_date_int)
        
        # Find payment by checkout_request_id (not AccountReference)
        payment = Payment.find_by(checkout_request_id: checkout_request_id)
        
        if payment
          payment.update!(
            status: 'Completed',
            mpesa_receipt_number: mpesa_receipt,
            amount: amount,
            phone: phone,
            transaction_date: transaction_date
          )
          
          Rails.logger.info "Payment #{payment.id} updated successfully with receipt #{mpesa_receipt}"
          render json: { message: 'Callback processed successfully' }, status: :ok
        else
          Rails.logger.error "Payment not found for CheckoutRequestID: #{checkout_request_id}"
          render json: { error: 'Payment not found' }, status: :not_found
        end
      else
        # Payment failed - update status to Failed
        payment = Payment.find_by(checkout_request_id: checkout_request_id)
        if payment
          payment.update!(
            status: 'Failed',
            failure_reason: result_desc
          )
          Rails.logger.info "Payment #{payment.id} marked as failed: #{result_desc}"
        end
        
        render json: { message: 'Payment failed', reason: result_desc }, status: :ok
      end
      
    rescue => e
      Rails.logger.error "MPESA CALLBACK ERROR: #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: "Callback processing failed", message: e.message }, status: :internal_server_error
    end
  end

  private

  # Convert M-Pesa date format (YYYYMMDDHHMMSS) to DateTime
  def convert_mpesa_date(mpesa_date_int)
    return nil unless mpesa_date_int
    
    date_str = mpesa_date_int.to_s
    if date_str.length == 14
      year = date_str[0..3].to_i
      month = date_str[4..5].to_i
      day = date_str[6..7].to_i
      hour = date_str[8..9].to_i
      minute = date_str[10..11].to_i
      second = date_str[12..13].to_i
      
      Time.zone.local(year, month, day, hour, minute, second)
    else
      Rails.logger.warn "Invalid M-Pesa date format: #{mpesa_date_int}"
      nil
    end
  end

  # privately hold payment_params
  private
  def payment_params
    params.require(:payment).permit(:device_id, :customer_id, :amount, :phone, :mpesa_receipt_number, :status)
  end
end
