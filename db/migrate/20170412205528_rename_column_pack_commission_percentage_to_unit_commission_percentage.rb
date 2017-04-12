class RenameColumnPackCommissionPercentageToUnitCommissionPercentage < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :pack_commission_percentage, :unit_commission_percentage
  end
end
