class AddAllowCartOrderingAtToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :allow_prize_cart_ordering_at, :date
    add_column :events, :number_of_top_sellers, :integer, default: 5
  end
end
