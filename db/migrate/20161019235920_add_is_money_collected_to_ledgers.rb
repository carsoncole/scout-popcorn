class AddIsMoneyCollectedToLedgers < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :is_money_collected, :boolean
  end
end
