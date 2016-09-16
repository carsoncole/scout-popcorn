class AddIsTransferFromBsaToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :is_transfer_from_bsa, :boolean
  end
end
