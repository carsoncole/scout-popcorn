class AddReceiptSentAtToTakeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :take_orders, :receipt_sent_at, :datetime
  end
end
