class AddIsActiveToScouts < ActiveRecord::Migration[5.0]
  def change
    add_column :scouts, :is_active, :boolean, default: true
  end
end
