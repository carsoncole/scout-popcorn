class AddLineItemIdToLedgers < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :line_item_id, :integer
  end
end
