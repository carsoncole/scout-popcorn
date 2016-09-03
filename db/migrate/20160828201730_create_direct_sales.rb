class CreateDirectSales < ActiveRecord::Migration[5.0]
  def change
    create_table :direct_sales do |t|
      t.integer :scout_id
      t.integer :event_id
      t.integer :product_id
      t.decimal :price, precision: 5, scale: 2, default: 0, null: false
      t.integer :quantity, default: 0, null: false
      t.decimal :amount, precision: 5, scale: 2, default: 0, null: false
      t.string :status, default: 'delivered', null: false
      t.timestamps
    end
  end
end
