class AddIsPhysicalInventoryToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :is_physical_inventory, :boolean, default: true
  end
end
