class CreateDoubleEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :double_entries do |t|

      t.timestamps
    end
  end
end
