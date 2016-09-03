class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.integer :unit_id
      t.integer :product_id
      t.integer :quantity
      t.string :location
      t.string :description
      t.integer :created_by
      t.timestamps
    end
  end
end