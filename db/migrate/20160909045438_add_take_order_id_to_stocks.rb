class AddTakeOrderIdToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :take_order_id, :integer
    add_column :stocks, :direct_sale_id, :integer
  end
end
