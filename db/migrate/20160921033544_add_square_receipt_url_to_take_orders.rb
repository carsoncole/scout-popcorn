class AddSquareReceiptUrlToTakeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :take_orders, :square_reciept_url, :string
  end
end
