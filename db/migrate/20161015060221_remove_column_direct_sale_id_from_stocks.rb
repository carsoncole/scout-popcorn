class RemoveColumnDirectSaleIdFromStocks < ActiveRecord::Migration[5.0]
  def change
    remove_column :stocks, :direct_sale_id, :integer
  end
end
