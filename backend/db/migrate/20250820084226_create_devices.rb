class CreateDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :brand
      t.string :model
      t.text :specs
      t.decimal :price
      t.decimal :discount

      t.timestamps
    end
  end
end
