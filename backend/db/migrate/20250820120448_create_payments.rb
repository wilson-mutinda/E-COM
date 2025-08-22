class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :device, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :mpesa_receipt_number

      t.timestamps
    end
  end
end
