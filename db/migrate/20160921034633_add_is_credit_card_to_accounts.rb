class AddIsCreditCardToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :is_credit_card, :boolean
  end
end
