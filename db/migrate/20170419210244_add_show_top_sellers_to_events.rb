class AddShowTopSellersToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :show_top_sellers, :boolean, default: true
  end
end
