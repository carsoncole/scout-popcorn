class CreateEnvelopes < ActiveRecord::Migration[5.0]
  def change
    create_table :envelopes do |t|
      t.integer :scout_id
      t.integer :event_id
      t.string :status
      t.integer :money_received_by_id
      t.datetime :money_received_at
      t.datetime :closed_at

      t.timestamps
    end
  end
end
