class CreateLedgers < ActiveRecord::Migration[5.0]
  def change
    create_table :ledgers do |t|
      t.integer :double_entry_id
      t.integer :account_id
      t.string :description
      t.decimal :amount, precision: 12, scale: 2, default: 0
      t.date :date
      t.boolean :is_money_collected
      t.integer :line_item_id
      t.integer :take_order_id
      t.integer :site_sale_id
      t.integer :stock_id
      t.boolean :is_take_order_product_related
      t.datetime :bank_deposit_notification_sent_at
      t.integer :created_by
      t.integer :created_at

      t.timestamps
    end
  end
end