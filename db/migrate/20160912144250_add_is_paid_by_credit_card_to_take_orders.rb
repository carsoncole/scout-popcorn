class AddIsPaidByCreditCardToTakeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :take_orders, :is_paid_by_credit_card, :boolean, default: false
    add_column :take_orders, :credit_card_order_number, :integer
  end
end
