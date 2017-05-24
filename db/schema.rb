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

ActiveRecord::Schema.define(version: 20170513015256) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.string   "simple_name"
    t.string   "account_type"
    t.integer  "rank",                        default: 0
    t.boolean  "is_master_account",           default: true
    t.boolean  "is_cash",                     default: false
    t.boolean  "is_third_party_account",      default: false
    t.boolean  "is_due_to_bsa",               default: false
    t.boolean  "is_take_order_eligible",      default: false
    t.boolean  "is_site_sale_eligible",       default: false
    t.boolean  "is_bank_account_depositable", default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "cart_prizes", force: :cascade do |t|
    t.integer  "prize_cart_id"
    t.integer  "prize_id"
    t.integer  "prize_amount"
    t.integer  "quantity",      default: 0,     null: false
    t.boolean  "is_automatic",  default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "double_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "envelopes", force: :cascade do |t|
    t.integer  "scout_id"
    t.integer  "event_id"
    t.string   "status"
    t.integer  "money_received_by_id"
    t.datetime "money_received_at"
    t.datetime "closed_at"
    t.integer  "closed_by"
    t.integer  "created_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "product_picked_up_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "name"
    t.boolean  "is_active",                                             default: true,   null: false
    t.string   "admin_email"
    t.decimal  "unit_commission_percentage",    precision: 5, scale: 2, default: "35.0", null: false
    t.decimal  "online_commission_percentage",  precision: 5, scale: 2, default: "35.0", null: false
    t.datetime "take_orders_deadline_at"
    t.date     "prize_cart_ordering_starts_at"
    t.boolean  "is_online_enabled",                                     default: true
    t.boolean  "is_take_orders_enabled",                                default: true
    t.boolean  "is_prizes_enabled",                                     default: true
    t.boolean  "show_top_sellers",                                      default: true
    t.boolean  "is_site_sales_enabled",                                 default: true
    t.integer  "number_of_top_sellers",                                 default: 5
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.date     "prize_cart_ordering_ends_at"
  end

  create_table "ledgers", force: :cascade do |t|
    t.integer  "double_entry_id"
    t.integer  "account_id"
    t.string   "description"
    t.decimal  "amount",                            precision: 12, scale: 2, default: "0.0"
    t.date     "date"
    t.boolean  "is_money_collected"
    t.integer  "line_item_id"
    t.integer  "take_order_id"
    t.integer  "site_sale_id"
    t.integer  "stock_id"
    t.integer  "online_sale_id"
    t.integer  "prize_cart_id"
    t.boolean  "is_take_order_product_related"
    t.datetime "bank_deposit_notification_sent_at"
    t.integer  "created_by"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
  end

  create_table "online_sales", force: :cascade do |t|
    t.integer  "scout_id"
    t.integer  "event_id"
    t.date     "order_date"
    t.string   "customer_name"
    t.string   "description"
    t.decimal  "amount",        precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "prize_carts", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "scout_id"
    t.datetime "is_ordered_at"
    t.datetime "is_approved_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "prizes", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.decimal  "sales_amount",          precision: 5, scale: 2
    t.string   "description"
    t.string   "source"
    t.string   "source_description"
    t.string   "source_id"
    t.boolean  "is_by_level"
    t.string   "url"
    t.string   "group"
    t.string   "collection_name"
    t.decimal  "cost",                  precision: 5, scale: 2, default: "0.0", null: false
    t.boolean  "reduces_sales_credits",                         default: true
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.decimal  "retail_price",          precision: 5, scale: 2
    t.string   "url"
    t.boolean  "is_active",                                     default: true
    t.boolean  "is_physical_inventory",                         default: true
    t.boolean  "is_pack_donation",                              default: false
    t.boolean  "is_sourced_from_bsa",                           default: true
    t.string   "sourced_from"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "type",                        null: false
    t.string   "status",     default: "open", null: false
    t.datetime "ordered_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string   "password_digest",        default: "",    null: false
    t.integer  "event_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean  "is_active",              default: true
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.boolean  "is_unit_admin",          default: false
    t.boolean  "is_financial_admin",     default: false
    t.boolean  "is_take_orders_admin",   default: false
    t.boolean  "is_site_sales_admin",    default: false
    t.boolean  "is_online_sales_admin",  default: false
    t.boolean  "is_prizes_admin",        default: false
    t.boolean  "is_warehouse_admin",     default: false
    t.boolean  "is_admin",               default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "site_sale_line_items", force: :cascade do |t|
    t.integer  "site_sale_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.decimal  "value",        precision: 5, scale: 2
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "site_sale_payment_methods", force: :cascade do |t|
    t.integer  "site_sale_id"
    t.integer  "account_id"
    t.decimal  "amount",       precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "site_sales", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.date     "date"
    t.integer  "closed_by"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "location"
    t.string   "description"
    t.decimal  "wholesale_value",            precision: 12, scale: 2, default: "0.0", null: false
    t.integer  "take_order_id"
    t.integer  "site_sale_id"
    t.integer  "created_by"
    t.boolean  "is_transfer_from_bsa",                                default: false
    t.boolean  "is_transfer_from_warehouse",                          default: false
    t.boolean  "is_pickup"
    t.integer  "ledger_id"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.date     "date"
  end

  create_table "take_order_line_items", force: :cascade do |t|
    t.integer  "take_order_id"
    t.integer  "product_id"
    t.integer  "quantity",                              default: 0,     null: false
    t.decimal  "value",         precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "take_orders", force: :cascade do |t|
    t.integer  "envelope_id"
    t.integer  "purchase_order_id"
    t.string   "status",                                           default: "received", null: false
    t.string   "customer_name"
    t.string   "customer_address"
    t.string   "customer_email"
    t.integer  "payment_account_id"
    t.decimal  "total_value",              precision: 5, scale: 2
    t.integer  "money_received_by_id"
    t.datetime "money_received_at"
    t.boolean  "is_paid_by_credit_card",                           default: false
    t.integer  "credit_card_order_number"
    t.string   "note"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.datetime "receipt_sent_at"
    t.string   "square_reciept_url"
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "zip_code"
    t.string   "state_postal_code"
    t.string   "treasurer_first_name"
    t.string   "treasurer_last_name"
    t.string   "treasurer_email"
    t.boolean  "send_email_on_registration", default: false
    t.boolean  "send_emails",                default: true
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

end
