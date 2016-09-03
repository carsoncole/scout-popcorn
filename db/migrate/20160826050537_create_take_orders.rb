class CreateTakeOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :take_orders do |t|
      t.integer :scout_id
      t.integer :event_id
      t.integer :purchase_order_id
      t.string :status, default: 'received', null: false
      t.string :customer_name
      t.string :customer_address
      t.string :customer_email
      t.decimal :total_value, precision: 5, scale: 2
      t.integer :money_received_by_id
      t.datetime :money_received_at
      t.timestamps
    end
  end
end
