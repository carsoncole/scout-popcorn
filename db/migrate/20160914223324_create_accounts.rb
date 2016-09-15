class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.integer :unit_id
      t.string :name

      t.timestamps
    end
  end
end
