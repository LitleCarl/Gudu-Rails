# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151112071332) do

  create_table "addresses", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "address",         limit: 255
    t.string   "phone",           limit: 255
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "default_address",             default: false
  end

  create_table "authorizations", force: :cascade do |t|
    t.string   "open_id",       limit: 255
    t.string   "provider",      limit: 255
    t.string   "token",         limit: 255
    t.string   "refresh_token", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "union_id",      limit: 255
  end

  create_table "body_infos", force: :cascade do |t|
    t.integer  "height",     limit: 4
    t.integer  "weight",     limit: 4
    t.boolean  "gender",               default: false
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "campuses", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.string   "address",       limit: 255, null: false
    t.string   "logo_filename", limit: 255
    t.integer  "city_id",       limit: 4
    t.string   "location",      limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer  "quantity",         limit: 4, default: 1
    t.integer  "product_id",       limit: 4,             null: false
    t.integer  "specification_id", limit: 4,             null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.string   "abbreviation", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.datetime "active_from",           null: false
    t.datetime "active_to",             null: false
    t.integer  "store_id",    limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.decimal  "discount",                 precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "activated_date",                                                  null: false
    t.datetime "expired_date",                                                    null: false
    t.integer  "user_id",        limit: 4
    t.integer  "status",         limit: 4,                                        null: false
    t.decimal  "least_price",              precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "order_id",       limit: 4
  end

  create_table "nutritions", force: :cascade do |t|
    t.float    "energy",       limit: 24, default: 0.0
    t.float    "fat",          limit: 24, default: 0.0
    t.float    "carbohydrate", limit: 24, default: 0.0
    t.float    "sugar",        limit: 24, default: 0.0
    t.float    "natrium",      limit: 24, default: 0.0
    t.integer  "product_id",   limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "quantity",         limit: 4,                          default: 1,   null: false
    t.decimal  "price_snapshot",             precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "product_id",       limit: 4,                                        null: false
    t.integer  "order_id",         limit: 4,                                        null: false
    t.integer  "specification_id", limit: 4,                                        null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status",           limit: 4,                              default: 1,   null: false
    t.decimal  "price",                          precision: 10, scale: 2, default: 0.0, null: false
    t.string   "delivery_time",    limit: 255,                                          null: false
    t.string   "receiver_name",    limit: 255,                                          null: false
    t.string   "receiver_phone",   limit: 255,                                          null: false
    t.string   "receiver_address", limit: 255,                                          null: false
    t.integer  "campus_id",        limit: 4
    t.integer  "user_id",          limit: 4
    t.string   "pay_method",       limit: 255,                                          null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.text     "charge_json",      limit: 65535
    t.string   "order_number",     limit: 255
    t.decimal  "pay_price",                      precision: 10, scale: 2, default: 0.0
  end

  create_table "owners", force: :cascade do |t|
    t.string   "username",      limit: 255,                                              null: false
    t.string   "password",      limit: 255, default: "e10adc3949ba59abbe56e057f20f883e", null: false
    t.string   "contact_name",  limit: 255,                                              null: false
    t.string   "contact_phone", limit: 255,                                              null: false
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string   "payment_method", limit: 255,                                          null: false
    t.datetime "time_paid",                                                           null: false
    t.decimal  "amount",                       precision: 10, scale: 2, default: 0.0, null: false
    t.string   "transaction_no", limit: 255,                                          null: false
    t.string   "charge_id",      limit: 255,                                          null: false
    t.integer  "order_id",       limit: 4,                                            null: false
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.text     "pingpp_info",    limit: 65535
  end

  create_table "product_images", force: :cascade do |t|
    t.string   "image_name", limit: 255,             null: false
    t.integer  "priority",   limit: 4,   default: 0
    t.integer  "product_id", limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "store_id",      limit: 4,                    null: false
    t.string   "name",          limit: 255,                  null: false
    t.string   "logo_filename", limit: 255,                  null: false
    t.string   "brief",         limit: 255, default: "暂无简介"
    t.string   "min_price",     limit: 255, default: "0.0"
    t.string   "max_price",     limit: 255, default: "0.0"
    t.string   "category",      limit: 255,                  null: false
    t.integer  "status",        limit: 4,   default: 1,      null: false
    t.string   "pinyin",        limit: 255
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "month_sale",    limit: 4,   default: 23
  end

  create_table "specifications", force: :cascade do |t|
    t.string   "name",          limit: 255,                                        null: false
    t.string   "value",         limit: 255,                                        null: false
    t.decimal  "price",                     precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "product_id",    limit: 4,                                          null: false
    t.integer  "status",        limit: 4,                            default: 1,   null: false
    t.integer  "stock",         limit: 4,                            default: 0
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.integer  "stock_per_day", limit: 4,                            default: 10,  null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name",           limit: 255,                    null: false
    t.string   "brief",          limit: 255,   default: "暂无简介", null: false
    t.string   "address",        limit: 255,                    null: false
    t.string   "logo_filename",  limit: 255,                    null: false
    t.string   "location",       limit: 255
    t.string   "pinyin",         limit: 255
    t.integer  "status",         limit: 4,     default: 1
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.text     "signature",      limit: 65535
    t.integer  "month_sale",     limit: 4,     default: 0
    t.float    "back_ratio",     limit: 24,    default: 0.0
    t.text     "main_food_list", limit: 65535
    t.integer  "owner_id",       limit: 4
  end

  create_table "stores_campuses", force: :cascade do |t|
    t.integer  "store_id",   limit: 4
    t.integer  "campus_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "sub_orders", force: :cascade do |t|
    t.integer  "owner_id",    limit: 4,                                        null: false
    t.integer  "order_id",    limit: 4,                                        null: false
    t.decimal  "price",                 precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "origin_date",                                                  null: false
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone",      limit: 255,                                              null: false
    t.string   "password",   limit: 255, default: "e10adc3949ba59abbe56e057f20f883e", null: false
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
  end

end
