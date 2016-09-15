class CreateSiteSalePaymentMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :site_sale_payment_methods do |t|
      t.integer :site_sale_id
      t.integer :account_id
      t.decimal :amount, precision: 5, scale: 2, default: 0

      t.timestamps
    end
  end
end
