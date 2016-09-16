class AddSiteSaleIdToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :site_sale_id, :integer
  end
end
