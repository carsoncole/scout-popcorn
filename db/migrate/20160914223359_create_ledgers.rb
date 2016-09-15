class CreateLedgers < ActiveRecord::Migration[5.0]
  def change
    create_table :ledgers do |t|
      t.integer :account_id
      t.string :description
      t.decimal :amount, precision: 5, scale: 2, default: 0
      t.date :date

      t.timestamps
    end
  end
end
