class DropTableDirectSales < ActiveRecord::Migration[5.0]
  def change
    drop_table :direct_sales
  end
end
