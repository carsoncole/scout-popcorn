class ChangeColumnAmountDecimalsOnLedgers < ActiveRecord::Migration[5.0]
  def up
    change_column :ledgers, :amount, :decimal, precision: 12, scale: 2, default: 0
  end
end
