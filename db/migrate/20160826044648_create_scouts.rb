class CreateScouts < ActiveRecord::Migration[5.0]
  def change
    create_table :scouts do |t|
      t.integer :unit_id
      t.string :first_name
      t.string :last_name
      t.string :parent_first_name
      t.string :parent_last_name
      t.string :email
      t.string :password_digest, null: false, default: ""
      t.integer :event_id
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :is_active, default: true
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.boolean :is_admin
      t.boolean :is_take_orders_admin, default: false
      t.boolean :is_site_sales_admin, default: false
      t.boolean :is_online_sales_admin, default: false
      t.boolean :is_prizes_admin, default: false

      t.boolean :is_super_admin
      t.timestamps
    end
  end

end
