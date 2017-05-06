class CreateSiteSales < ActiveRecord::Migration[5.0]
  def change
    create_table :site_sales do |t|
      t.integer :event_id
      t.string :name
      t.date :date
      t.integer :closed_by
      t.datetime :closed_at

      t.timestamps
    end
  end
end