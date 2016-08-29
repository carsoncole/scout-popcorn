class CreatePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.integer :event_id
      t.string :type, null: false
      t.string :status, default: 'open', null: false
      t.datetime :ordered_at
      t.timestamps
    end
  end
end
