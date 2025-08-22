class Api::V1::CustomersController < ApplicationController

  # create_customer
  def create_customer
    begin

      # user_params
      # email_param
      email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
      if email_param.blank?
        render json: { errors: { email: "Email is required!"}}, status: :unprocessable_entity
        return
      else
        # user with the email should not exist
        email = User.find_by(email: email_param)
        if email
          render json: { errors: { email: "Email Exists!"}}, status: :unprocessable_entity
          return
        end
        
        # email_format
        email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
        unless email_param.match(email_format)
          render json: { errors: { email: "Invalid email format!"}}, status: :unprocessable_entity
          return
        else
          email_param = email_param.to_s.gsub(/\s+/, '').downcase
        end
      end

      # phone_param
      phone_param = user_params[:phone].to_s
      if phone_param.blank?
        render json: { errors: { phone: "Phone is required!"}}, status: :unprocessable_entity
        return
      else
        # user with the same phone should not exist
        phone = User.find_by(phone: phone_param)
        if phone
          render json: { errors: { phone: "Phone Exists!"}}, status: :unprocessable_entity
          return
        end
        # phone_format
        phone_format = /\A(2541|2547)\d{8}\z/
        unless phone_param.match(phone_format)
          render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
          return
        else
          phone_format = phone_format.to_s
        end
      end

      # password_param and password_confirmation_param
      password_param = user_params[:password].to_s
      password_confirmation_param = user_params[:password_confirmation].to_s

      if password_param.present? || password_confirmation_param.present?

        if !password_param || !password_confirmation_param
          render json: { errors: { password_confirmation: "Both fields are required!"}}, status: :unprocessable_entity
          return
        end

        if password_param.length < 8
          render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
          return
        end

        unless password_param.match(/[A-Za-z]/) && password_param.match(/\d/)
          render json: { errors: { password: "Password should have both digits and characters"}}, status: :unprocessable_entity
          return
        end

        if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
          render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
          return
        end

      end
      password_param = password_param.to_s
      password_confirmation_param = password_confirmation_param.to_s

      # customer_params
      # first_name_param
      first_name_param = customer_params[:first_name].to_s.gsub(/\s+/, '').downcase
      if first_name_param.blank?
        render json: { errors: { first_name: "First name required!"}}, status: :unprocessable_entity
        return
      else
        first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
      end

      # last_name_param
      last_name_param = customer_params[:last_name].to_s.gsub(/\s+/, '').downcase
      if last_name_param.blank?
        render json: { errors: { last_name: "Last name required!"}}, status: :unprocessable_entity
        return
      else
        last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
      end

      # username_param
      username_param = customer_params[:username].to_s.gsub(/\s+/, '').downcase
      if username_param.blank?
        render json: { errors: { username: "Username is required!"}}, status: :unprocessable_entity
        return
      else
        # username should not exist
        username = Customer.find_by("LOWER(username) = ?", username_param)
        if username
          render json: { errors: { username: "Username exists!"}}, status: :unprocessable_entity
          return
        else
          username_param = username_param.to_s.gsub(/\s+/, '').capitalize
        end
      end

      # create_user
      created_user = User.create(
        email: email_param,
        phone: phone_param,
        password: password_param,
        password_confirmation: password_confirmation_param,
        flag: "Customer"
      )
      
      if created_user
        # create_customer
        created_customer = Customer.create(
          user_id: created_user.id,
          first_name: first_name_param,
          last_name: last_name_param,
          username: username_param
        )

        if created_customer
          render json: { message: "Customer Created!"}, status: :created
        else
          render json: { error: "Error creating Customer!", info: created_customer.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Error creating user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # fetch single_customer
  def single_customer
    begin
      customer = Customer.find_by(id: params[:id])
      if customer
        email = customer.user.email
        phone = customer.user.phone
        flag = customer.user.flag
        info = customer.as_json(except: [:created_at, :updated_at]).merge({ email: email, phone: phone, flag: flag})
        render json: info, status: :ok
      else
        render json: { error: "Customer Deatils Not Found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # fetch all_customers
  def all_customers
    begin
      customers = Customer.all
      if customers.empty?
        render json: { error: "No Records Found!"}, status: :not_found
        return
      else
        info = customers.map do |customer|
          email = customer.user.email
          phone = customer.user.phone
          flag = customer.user.flag

        customer.as_json(except: [:created_at, :updated_at]).merge({ email: email, phone: phone, flag: flag})
          
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # update_customer
  def update_customer
    begin
      customer = Customer.find_by(id: params[:id])
      if customer

        user_info = {}
        customer_info = {}
        # user_params
        # email_param
        email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
        if email_param.present?

          # email_format
          email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
          unless email_param.match(email_format)
            render json: { errors: { email: "Invalid email format!"}}, status: :unprocessable_entity
            return
          else
            email_param = email_param.to_s.gsub(/\s+/, '').downcase
          end

          # email should not exist
          email = User.find_by(email: email_param)
          if email && email.id != customer.user.id
            render json: { errors: { email: "Email Already Exists!"}}, status: :unprocessable_entity
            return
          else
            email_param = email_param.to_s.gsub(/\s+/, '').downcase
          end

          user_info[:email] = email_param
        end

        # phone_param
        phone_param = user_params[:phone].to_s
        if phone_param.present?

          # phone_format
          phone_format = /\A(2541|2547)\d{8}\z/
          unless phone_param.match(phone_format)
            render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
            return
          else
            phone_format = phone_format.to_s
          end

          # phone should not exist
          phone = User.find_by(phone: phone_param)
          if phone && phone.id != customer.user.id
            render json: { errors: { phone: "Phone Already Exists!"}}, status: :unprocessable_entity
            return
          else
            phone_param = phone_param.to_s
          end
          user_info[:phone] = phone_param
        end

        # password_param
        password_param = user_params[:password].to_s
        # password_confirmation_param
        password_confirmation_param = user_params[:password_confirmation].to_s

        if password_param.present? || password_confirmation_param.present?

          if !password_param || !password_confirmation_param
            render json: { errors: { password_confirmation: "Both fields are required!"}}, status: :unprocessable_entity
            return
          end

          if password_param.length < 8
            render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
            return
          end

          unless password_param.match(/[A-Za-z]/) && password_param.match(/\d/)
            render json: { errors: { password: "Password should have both digits and characters"}}, status: :unprocessable_entity
            return
          end

          if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
            render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
            return
          end
          user_info[:password] = password_param
          user_info[:password_confirmation] = password_confirmation_param
        end

        # customer_params
        # first_name_param
        first_name_param = customer_params[:first_name].to_s.gsub(/\s+/, '').downcase
        if first_name_param.present?
          first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
          customer_info[:first_name] = first_name_param
        end

        # last_name_param
        last_name_param = customer_params[:last_name].to_s.gsub(/\s+/, '').downcase
        if last_name_param.present?
          last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
          customer_info[:last_name] = last_name_param
        end

        # username_param
        username_param = customer_params[:username].to_s.gsub(/\s+/, '').downcase
        if username_param.present?
          # username should not exist
          username = Customer.where("LOWER(username) = ?", username_param).where.not(id: customer.id).first
          if username
            render json: { errors: { username: "Username Already Exists!"}}, status: :unprocessable_entity
            return
          else
            username_param = username_param.to_s.gsub(/\s+/, '').capitalize
            customer_info[:username] = username_param
          end
        end

        # update_user
        updated_user = User.update(
          user_info
        )
        if updated_user
          # update_customer
          updated_customer = Customer.update(
            customer_info
          )
          if updated_customer
            render json: { message: "Customer Updated Successfully!"}, status: :ok
          else
            render json: { error: "Error Updating Customer", info: customer.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Error updating user", info: customer.user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Customer not found!"}, status: :not_found
      end
    rescue => e 
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # delete_customer
  def delete_customer
    begin
      customer = Customer.find_by(id: params[:id])
      if customer
        user = customer.user

        # delete customer first
        customer.destroy
        # delete user next
        user.destroy

        render json: { message: "Customer deleted successfully!"}, status: :ok
      else
        render json: { error: "Customer Details Not Found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :unprocessable_entity
    end
  end

  # privately hold customer_params and user_params
  private
  def customer_params
    params.require(:customer).permit(:user_id, :first_name, :last_name, :username)
  end

  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation, :flag)
  end
end
