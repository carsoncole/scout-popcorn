class AddAccountIdToTakeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :take_orders, :account_id, :integer
  end
end
