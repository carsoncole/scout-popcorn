class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :unit_id
      t.string :name
      t.boolean :is_active, default: true, null: false
      t.string :contact_person_email
      t.decimal :pack_commission_percentage, precision: 5, scale: 2, default: 35, null: false
      t.decimal :online_commission_percentage, precision: 5, scale: 2, default: 35, null: false
      t.datetime :take_orders_deadline_at
      t.date :allow_prize_cart_ordering_at
      t.boolean :is_online_enabled, default: true
      t.boolean :is_take_orders_enabled, default: true
      t.boolean :is_prizes_enabled, default: true
      t.boolean :show_top_sellers, default: true
      t.boolean :is_site_sales_enabled, default: true
      t.integer :number_of_top_sellers, default: 5
      t.timestamps
    end
  end
end
