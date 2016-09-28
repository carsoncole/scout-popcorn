class CreateScoutPrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :scout_prizes do |t|
      t.integer :scout_id
      t.integer :event_id
      t.integer :prize_id
      t.integer :prize_amount
      t.boolean :is_complete
      t.datetime :is_complete_at
      t.boolean :is_approved

      t.timestamps
    end
  end
end
