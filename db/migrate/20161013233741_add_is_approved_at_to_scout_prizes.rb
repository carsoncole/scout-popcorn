class AddIsApprovedAtToScoutPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :scout_prizes, :is_approved_at, :datetime
    remove_column :scout_prizes, :is_approved, :boolean
    remove_column :scout_prizes, :is_complete, :boolean
  end
end
