class AddAccountTypeToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :account_type, :string
  end
end
