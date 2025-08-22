class ChangeSpecsToJsonbInDevices < ActiveRecord::Migration[8.0]
  def change
    change_column :devices, :specs, :jsonb, using: 'specs::jsonb'
  end
end
