class AddIsPrizesAdminToScouts < ActiveRecord::Migration[5.0]
  def change
    add_column :scouts, :is_prizes_admin, :boolean
  end
end