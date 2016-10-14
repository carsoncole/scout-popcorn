class CreatePrizeCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :prize_carts do |t|
      t.integer :event_id
      t.integer :scout_id
      t.datetime :is_ordered_at
      t.datetime :is_approved_at
      t.timestamps
    end
  end
end
