class AddCostToPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :prizes, :cost, :decimal, precision: 5, scale: 2
  end
end
