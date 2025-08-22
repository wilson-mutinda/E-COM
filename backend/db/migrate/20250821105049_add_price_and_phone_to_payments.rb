class AddPriceAndPhoneToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :phone, :string
    add_column :payments, :amount, :string
  end
end
