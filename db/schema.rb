# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160828201730) do

  create_table "direct_sales", force: :cascade do |t|
    t.integer  "scout_id"
    t.integer  "event_id"
    t.integer  "product_id"
    t.decimal  "price",      precision: 5, scale: 2, default: "0.0",  null: false
    t.integer  "quantity",                           default: 0,      null: false
    t.decimal  "amount",     precision: 5, scale: 2, default: "0.0",  null: false
    t.string   "status",                             default: "open", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "name"
    t.boolean  "is_active",  default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "take_order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.decimal  "value",         precision: 5, scale: 2
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "prizes", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.decimal  "amount",     precision: 5, scale: 2
    t.string   "url"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.integer  "quantity"
    t.decimal  "retail_price", precision: 5, scale: 2
    t.string   "url"
    t.boolean  "is_active",                            default: true
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "type",                        null: false
    t.string   "status",     default: "open", null: false
    t.datetime "ordered_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "scout_site_sales", force: :cascade do |t|
    t.integer  "scout_id"
    t.integer  "site_sale_id"
    t.decimal  "hours_worked", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "scouts", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "default_event_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_admin"
    t.boolean  "is_super_admin"
    t.index ["email"], name: "index_scouts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_scouts_on_reset_password_token", unique: true
  end

  create_table "site_sales", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.decimal  "total_sales", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "take_orders", force: :cascade do |t|
    t.integer  "scout_id"
    t.integer  "event_id"
    t.integer  "purchase_order_id"
    t.string   "status",            default: "open", null: false
    t.string   "customer_name"
    t.string   "customer_address"
    t.string   "customer_email"
    t.decimal  "total_value"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "zip_code"
    t.string   "state_postal_code"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end