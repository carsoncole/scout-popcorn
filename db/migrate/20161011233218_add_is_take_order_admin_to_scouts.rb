class AddIsTakeOrderAdminToScouts < ActiveRecord::Migration[5.0]
  def change
    add_column :scouts, :is_take_order_admin, :boolean, default: false
    add_column :scouts, :is_site_sale_admin, :boolean, default: false
  end
end
