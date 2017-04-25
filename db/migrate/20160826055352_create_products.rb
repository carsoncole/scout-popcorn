class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :event_id
      t.string :name
      t.decimal :retail_price, precision: 5, scale: 2
      t.string :url
      t.boolean :is_active, default: true
      t.boolean :is_physical_inventory, default: true
      t.timestamps
    end
  end
end
