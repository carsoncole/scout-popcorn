class AddOnlineCommissionPercentageToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :online_commission_percentage, :decimal, precision: 5, scale: 2, default: 35
  end
end
