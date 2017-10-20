class AddIsTransferToBsaToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :is_transfer_to_bsa, :boolean
  end
end
