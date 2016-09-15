class AddTakeOrderIdToLedgers < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :take_order_id, :integer
  end
end
