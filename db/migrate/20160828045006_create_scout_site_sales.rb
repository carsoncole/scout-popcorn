class CreateScoutSiteSales < ActiveRecord::Migration[5.0]
  def change
    create_table :scout_site_sales do |t|
      t.integer :scout_id
      t.integer :site_sale_id
      t.decimal :hours_worked, precision: 5, scale: 2, default: 0, null: false
      t.timestamps
    end
  end
end
