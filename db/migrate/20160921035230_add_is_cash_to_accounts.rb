class AddIsCashToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :is_cash, :boolean
  end
end
