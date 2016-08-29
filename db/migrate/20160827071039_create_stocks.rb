class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.integer :unit_id
      t.integer :product_id
      t.integer :quantity

      t.timestamps
    end
  end
end
