class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.integer :event_id
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
