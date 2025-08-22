class AddStatusToPayment < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :status, :string
  end
end
