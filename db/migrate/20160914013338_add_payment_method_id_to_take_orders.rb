class AddPaymentMethodIdToTakeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :take_orders, :payment_method_id, :integer
  end
end
