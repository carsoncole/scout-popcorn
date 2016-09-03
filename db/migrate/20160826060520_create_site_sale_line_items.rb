class CreateSiteSaleLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :site_sale_line_items do |t|
      t.integer :site_sale_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :value, precision: 5, scale: 2

      t.timestamps
    end
  end
end