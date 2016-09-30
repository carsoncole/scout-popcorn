class AddPackCommissionPercentageToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :pack_commission_percentage, :decimal, precision: 5, scale: 2, default: 32
  end
end
