class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.integer :event_id
      t.integer :product_id
      t.integer :quantity
      t.string :location
      t.string :description
      t.decimal :wholesale_value, precision: 12, scale: 2, default: 0, null: false
      t.integer :take_order_id
      t.integer :site_sale_id
      t.integer :created_by
      t.boolean :is_transfer_from_bsa
      t.boolean :is_pickup
      t.integer :ledger_id
      t.timestamps
    end
  end
end