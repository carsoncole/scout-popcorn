class RenameScoutPrizesToCartPrizes < ActiveRecord::Migration[5.0]
  def change
    rename_table :scout_prizes, :cart_prizes
  end
end