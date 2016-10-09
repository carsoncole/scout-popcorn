class AddIsSourcedFromBsaToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :is_sourced_from_bsa, :boolean, default: true
  end
end
