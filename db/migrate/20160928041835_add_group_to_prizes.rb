class AddGroupToPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :prizes, :group, :string
  end
end
