Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'create_user', to: 'users#create_user'

      post 'user_login', to: 'users#user_login'

      post 'create_customer', to: 'customers#create_customer'
      get 'single_customer/:id', to: 'customers#single_customer'
      get 'all_customers', to: 'customers#all_customers'
      patch 'update_customer/:id', to: 'customers#update_customer'
      delete 'delete_customer/:id', to: 'customers#delete_customer'

      post 'create_device', to: 'devices#create_device'
      get 'single_device/:id', to: 'devices#single_device'
      get 'all_devices', to: 'devices#all_devices'
      patch 'update_device/:id', to: 'devices#update_device'
      delete 'delete_device/:id', to: 'devices#delete_device'

      post 'create_payment', to: 'payments#create_payment'
      post 'mpesa_callback', to: 'payments#mpesa_callback'
    end
  end
end
