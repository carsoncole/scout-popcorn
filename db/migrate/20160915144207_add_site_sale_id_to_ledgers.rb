class AddSiteSaleIdToLedgers < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :site_sale_id, :integer
  end
end
