class AddPrizeCartIdToScoutPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :scout_prizes, :prize_cart_id, :integer
  end
end
