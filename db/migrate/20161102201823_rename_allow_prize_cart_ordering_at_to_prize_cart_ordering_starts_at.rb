class RenameAllowPrizeCartOrderingAtToPrizeCartOrderingStartsAt < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :allow_prize_cart_ordering_at, :prize_cart_ordering_starts_at
    add_column :events, :prize_cart_ordering_ends_at, :date
  end
end
