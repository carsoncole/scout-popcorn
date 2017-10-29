class CreateSalesCredits < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_credits do |t|
      t.integer :event_id
      t.integer :scout_id
      t.string :description
      t.decimal :amount, precision: 9, scale: 2, default: 0, null: false

      t.timestamps
    end
  end
end
