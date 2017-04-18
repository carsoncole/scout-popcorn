class AddIsOnlineEnabledToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :is_online_enabled, :boolean, default: true
    add_column :events, :is_take_orders_enabled, :boolean, default: true
    add_column :events, :is_site_sales_enabled, :boolean, default: true
  end
end
