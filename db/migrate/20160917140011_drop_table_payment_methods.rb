class DropTablePaymentMethods < ActiveRecord::Migration[5.0]
  def change
    drop_table :payment_methods
  end
end
