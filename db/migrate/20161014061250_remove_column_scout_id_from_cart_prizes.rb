class RemoveColumnScoutIdFromCartPrizes < ActiveRecord::Migration[5.0]
  def change
    remove_column :cart_prizes, :scout_id, :integer
    remove_column :cart_prizes, :event_id, :integer
    remove_column :cart_prizes, :is_complete_at, :datetime
    remove_column :cart_prizes, :is_approved_at, :datetime
  end
end
