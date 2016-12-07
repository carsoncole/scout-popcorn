class AddEventIdToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :event_id, :integer
    remove_column :stocks, :unit_id, :integer
  end
end
