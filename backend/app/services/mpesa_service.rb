require 'httparty'
require 'base64'

class MpesaService
  include HTTParty 
  base_uri "https://sandbox.safaricom.co.ke"

  def initialize
    @consumer_key = ENV['MPESA_CONSUMER_KEY']
    @consumer_secret = ENV['MPESA_CONSUMER_SECRET']
    @short_code = ENV['MPESA_SHORT_CODE']
    @callback_url = ENV['MPESA_CALLBACK_URL']
    @passkey = ENV['MPESA_PASSKEY']
  end

  def access_token
    auth = {
      username: @consumer_key,
      password: @consumer_secret
    }

    response = self.class.get("/oauth/v1/generate?grant_type=client_credentials", basic_auth: auth)
    JSON.parse(response.body)['access_token']
  end

  def stk_push(amount, phone, account_reference, description)

    token = access_token
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    password = Base64.strict_encode64("#{@short_code}#{@passkey}#{timestamp}")

    headers = {
      "Authorization": "Bearer #{token}",
      "Content-Type": "application/json"
    }

    body = {
      "BusinessShortCode": @short_code,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerPayBillOnline",
      "Amount": amount,
      "PartyA": phone,
      "PartyB": @short_code,
      "PhoneNumber": phone,
      "CallBackURL": @callback_url,
      "AccountReference": account_reference,
      "TransactionDesc": description
    }

    response = self.class.post("/mpesa/stkpush/v1/processrequest", headers: headers, body: body.to_json)
    JSON.parse(response.body)
  end
end
