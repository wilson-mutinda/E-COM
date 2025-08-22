class Api::V1::DevicesController < ApplicationController

  # create_device
  def create_device
    begin
      # device_params

      # name_param
      name_param = device_params[:name].to_s.gsub(/\s+/, '').downcase
      if name_param.blank?
        render json: { errors: { name: "Device name required!"}}, status: :unprocessable_entity
        return
      else
        name_param = name_param.to_s.gsub(/\s+/, '').capitalize
      end

      # brand_param
      brand_param = device_params[:brand].to_s.gsub(/\s+/, '').downcase
      if brand_param.blank?
        render json: { errors: { brand: "Brand name required!"}}, status: :unprocessable_entity
        return
      else
        brand_param = brand_param.to_s.gsub(/\s+/, '').capitalize
      end
      
      # model_param
      model_param = device_params[:model].to_s.gsub(/\s+/, '').downcase
      if model_param.blank?
        render json: { errors: { model: "Model name required!"}}, status: :unprocessable_entity
        return
      else
        model_param = model_param.to_s.gsub(/\s+/, '').capitalize
      end

      # specs_param
      specs_param = device_params[:specs]
      if specs_param.blank?
        render json: { errors: { specs: "Specs Needed!"}}, status: :unprocessable_entity
        return
      else
        specs_param = specs_param
      end

      # price_param
      price_param = device_params[:price]
      if price_param.blank?
        render json: { errors: { price: "Price needed!"}}, status: :unprocessable_entity
        return
      else
        price_param = price_param
      end

      # discount_param
      discount_param = device_params[:discount]
      if discount_param.blank?
        render json: { errors: { discount: "Discount needed!"}}, status: :unprocessable_entity
        return
      else
        discount_param = discount_param
      end

      # image_param
      image_param = device_params[:image]
      if image_param.blank?
        render json: { errors: { image: "Image is needed!"}}, status: :unprocessable_entity
        return
      else
        image_param = image_param
      end

      # create_device
      created_device = Device.create(
        name: name_param,
        brand: brand_param,
        model: model_param,
        specs: specs_param,
        price: price_param,
        discount: discount_param,
        image: image_param
      )

      if created_device
        render json: { message: "Device Created Successfully!"}, status: :created
      else
        render json: { error: "Devide not created!", info: created_device.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # fetch single_device
  def single_device
    begin
      device = Device.find_by(id: params[:id])
      if device
        image_url = url_for(device.image)
        info = device.as_json(except: [:image, :created_at, :updated_at]).merge({ image_url: image_url})
        render json: info, status: :ok
      else
        render json: { error: "Device not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # fetch all_devices
  def all_devices
    begin
      devices = Device.all
      if devices.empty?
        render json: { error: "Empty List!"}, status: :not_found
        return
      else
        info = devices.map do |device|
          image_url = url_for(device.image)

        device.as_json(except: [:image, :created_at, :updated_at]).merge({ image_url: image_url})
          
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # update_device
  def update_device
    begin
      device = Device.find_by(id: params[:id])
      if device

        device_info = {}
        # device_params

        # name_param
        name_param = device_params[:name].to_s.gsub(/\s+/, '').downcase
        if name_param.present?
          name_param = name_param.to_s.gsub(/\s+/, '').capitalize
          device_info[:name] = name_param
        end

        # brand_param
        brand_param = device_params[:brand].to_s.gsub(/\s+/, '').downcase
        if brand_param.present?
          brand_param = brand_param.to_s.gsub(/\s+/, '').capitalize
          device_info[:brand] = brand_param
        end

        # model_param
        model_param = device_params[:model].to_s.gsub(/\s+/, '').downcase
        if model_param.present?
          model_param = model_param.to_s.gsub(/\s+/, '').capitalize
          device_info[:model] = model_param
        end

        # specs_param
        specs_param = device_params[:specs]
        if specs_param.present?
          specs_param = specs_param
          device_info[:specs] = specs_param
        end

        # price_param
        price_param = device_params[:price]
        if price_param.present?
          price_param = price_param
          device_info[:price] = price_param
        end

        # discount_param
        discount_param = device_params[:discount]
        if discount_param.present?
          discount_param = discount_param
          device_info[:discount] = discount_param
        end

        # image_param
        image_param = device_params[:image]
        if image_param.present?
          image_param = image_param
          device_info[:image] = image_param 
        end

        # update_device
        updated_device = Device.update(
          device_info
        )

        if updated_device
          render json: { message: "Device Details Updated"}, status: :ok
        else
          render json: { error: "Error updating device", info: device.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Device Not Found!"}, status: :not_found
      end
    rescue => e
      render json: { errors: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # delete_device
  def delete_device
    begin
      device = Device.find_by(id: params[:id])
      if device
        device.destroy
        render json: { message: "Device Deleted Successfully!"}, status: :ok
      else
        render json: { error: "Device not found"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # privately hold device_params
  private
  def device_params
    params.require(:device).permit(:name, :brand, :model, :specs, :price, :discount, :image)
  end
end
