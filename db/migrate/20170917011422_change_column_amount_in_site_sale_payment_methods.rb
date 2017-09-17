class ChangeColumnAmountInSiteSalePaymentMethods < ActiveRecord::Migration[5.1]
  def change
    change_column :site_sale_payment_methods, :amount, :decimal, precision: 8, scale: 2, default: 0, null: false
  end
end
