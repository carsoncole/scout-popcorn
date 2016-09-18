class AddCreatedByToLedgers < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :created_by, :integer
  end
end
