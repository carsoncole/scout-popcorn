class CreateOnlineSales < ActiveRecord::Migration[5.0]
  def change
    create_table :online_sales do |t|
      t.integer :scout_id
      t.integer :event_id
      t.date :order_date
      t.string :customer_name
      t.string :description
      t.decimal :amount, precision: 5, scale: 2, default: 0, null: false

      t.timestamps
    end
  end
end
