class AddIsTakeOrderEligibleToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :is_take_order_eligible, :boolean, default: false
    add_column :accounts, :is_site_sale_eligible, :boolean, default: false
  end
end
