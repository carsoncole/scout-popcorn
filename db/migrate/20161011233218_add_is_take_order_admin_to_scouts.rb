class AddIsTakeOrderAdminToScouts < ActiveRecord::Migration[5.0]
  def change
    add_column :scouts, :is_take_orders_admin, :boolean, default: false
    add_column :scouts, :is_site_sales_admin, :boolean, default: false
    add_column :scouts, :is_online_sales_admin, :boolean, default: false
  end
end
