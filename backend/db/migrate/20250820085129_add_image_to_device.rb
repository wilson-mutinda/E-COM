class AddImageToDevice < ActiveRecord::Migration[8.0]
  def change
    add_column :devices, :image, :string
  end
end
