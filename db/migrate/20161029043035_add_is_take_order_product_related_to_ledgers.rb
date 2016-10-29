class AddIsTakeOrderProductRelatedToLedgers < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :is_take_order_product_related, :boolean
  end
end
