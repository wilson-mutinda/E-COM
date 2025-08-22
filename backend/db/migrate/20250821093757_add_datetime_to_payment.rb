class AddDatetimeToPayment < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :checkout_request_id, :string
    add_column :payments, :transaction_date, :datetime
  end
end
