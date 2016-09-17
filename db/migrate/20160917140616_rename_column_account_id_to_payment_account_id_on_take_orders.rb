class RenameColumnAccountIdToPaymentAccountIdOnTakeOrders < ActiveRecord::Migration[5.0]
  def change
    rename_column :take_orders, :account_id, :payment_account_id
  end
end
