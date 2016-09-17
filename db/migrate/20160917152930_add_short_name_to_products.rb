class AddShortNameToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :short_name, :string
  end
end
