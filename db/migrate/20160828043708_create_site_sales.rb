class CreateSiteSales < ActiveRecord::Migration[5.0]
  def change
    create_table :site_sales do |t|
      t.integer :event_id
      t.string :name
      t.decimal :total_sales, precision: 5, scale: 2, default: 0, null: false

      t.timestamps
    end
  end
end
