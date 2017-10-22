class ChangeColumnValueInTakeOrderLineItems < ActiveRecord::Migration[5.1]
  def change
    change_column :take_order_line_items, :value, :decimal, precision: 9, scale: 5, default: "0.0", null: false
    change_column :take_orders, :total_value, :decimal, precision: 9, scale: 5
    change_column :site_sale_line_items, :value, :decimal, precision: 9, scale: 5, default: "0.0", null: false
  end
end
