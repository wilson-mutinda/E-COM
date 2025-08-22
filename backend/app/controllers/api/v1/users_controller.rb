class Api::V1::UsersController < ApplicationController

  # create_user
  def create_user
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

      # create_user
      created_user = User.create(
        email: email_param,
        phone: phone_param,
        password: password_param,
        password_confirmation: password_confirmation_param,
        flag: "Admin"
      )
      if created_user
        render json: { message: "User created successfully!" }, status: :created
      else
        render json: { error: "Error creating user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # user_login
  def user_login
    begin
      # email_param
      email_param = params[:email].to_s.gsub(/\s+/, '').downcase
      # password_param
      password_param = params[:password].to_s

      user = User.find_by(email: email_param)
      if user
        auth = user.authenticate(password_param)
        if auth
          access_token = JsonWebToken.encode_token(user.id, 30.minutes.from_now)
          refresh_token = JsonWebToken.encode_token(user.id, 24.hours.from_now)
          render json: { 
            message: "Login Successfull",
            access_token: access_token,
            refresh_token: refresh_token
          }, status: :ok 
        else
          render json: { errors: { password: "Invalid Password"}}, status: :unprocessable_entity
        end
      else
        render json: { errors: { email: "Email not found!"}}, status: :not_found
      end
    rescue => e 
      render json: { error: "Something went wrong", message: e.message }, status: :internal_server_error
    end
  end

  # privately hold user_params
  private
  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation, :flag)
  end
end
