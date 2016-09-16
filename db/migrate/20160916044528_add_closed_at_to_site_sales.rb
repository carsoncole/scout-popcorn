class AddClosedAtToSiteSales < ActiveRecord::Migration[5.0]
  def change
    add_column :site_sales, :closed_at, :datetime
    add_column :site_sales, :closed_by_id, :integer
  end
end
