class CreateSalesCreditTotals < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_credit_totals do |t|
      t.integer :scout_id
      t.decimal :amount, precision: 7, scale:2, default: 0.0, null: false
      t.integer :event_id

      t.timestamps
    end
  end
end
