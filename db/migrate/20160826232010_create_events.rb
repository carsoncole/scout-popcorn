class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :unit_id
      t.string :name
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
  end
end
