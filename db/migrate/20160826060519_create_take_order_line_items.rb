class CreateTakeOrderLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :take_order_line_items do |t|
      t.integer :take_order_id
      t.integer :product_id
      t.integer :quantity, default: 0, null: false
      t.decimal :value, precision: 5, scale: 2, default:0, null: false

      t.timestamps
    end
  end
end
