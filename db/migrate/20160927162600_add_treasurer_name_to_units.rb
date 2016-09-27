class AddTreasurerNameToUnits < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :treasurer_first_name, :string
    add_column :units, :treasurer_last_name, :string
    add_column :units, :treasurer_email, :string
  end
end
