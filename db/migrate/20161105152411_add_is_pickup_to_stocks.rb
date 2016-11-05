class AddIsPickupToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :is_pickup, :boolean
  end
end
