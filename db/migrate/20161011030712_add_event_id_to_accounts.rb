class AddEventIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :event_id, :integer
  end
end
