class AddIsBankAccountDepositableToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :is_bank_account_depositable, :boolean, default: false
  end
end
