class CreateScouts < ActiveRecord::Migration[5.0]
  def change
    create_table :scouts do |t|
      t.integer :unit_id
      t.string :first_name
      t.string :last_name
      t.string :parent_first_name
      t.string :parent_last_name
      t.string :email
      t.integer :event_id
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
