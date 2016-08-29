class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.integer :take_order_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :value, precision: 5, scale: 2

      t.timestamps
    end
  end
end
