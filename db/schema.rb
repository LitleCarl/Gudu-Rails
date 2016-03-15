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

ActiveRecord::Schema.define(version: 20160315055512) do

  create_table "addresses", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "address",         limit: 255
    t.string   "phone",           limit: 255
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "default_address",             default: false
  end

  create_table "announcements", force: :cascade do |t|
    t.text     "content",    limit: 65535,                          comment: "通知内容"
    t.string   "link",       limit: 255,                            comment: "链接地址"
    t.integer  "platform",   limit: 4,     default: 0,              comment: "平台"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",           limit: 255,                comment: "提供者(wx,weibo)"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "union_id",           limit: 255,                comment: "用户唯一身份id"
    t.integer  "user_id",            limit: 4,                  comment: "关联用户"
    t.string   "nick_name",          limit: 255,                comment: "第三方昵称"
    t.integer  "owner_id",           limit: 4,                  comment: "关联店铺拥有人"
    t.text     "avatar",             limit: 65535,              comment: "头像地址"
    t.string   "gzh_token",          limit: 255,                comment: "公众号token"
    t.string   "gzh_refresh_token",  limit: 255,                comment: "公众号refresh_token"
    t.string   "open_token",         limit: 255,                comment: "开放平台token"
    t.string   "open_refresh_token", limit: 255,                comment: "开放平台refresh_token"
    t.string   "gzh_open_id",        limit: 255,                comment: "公众号open_id"
    t.string   "open_open_id",       limit: 255,                comment: "开放平台open_id"
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
    t.string   "first_letter",  limit: 255,              comment: "学校名称拼音首字母"
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

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255,              comment: "分类名称"
    t.integer  "priority",   limit: 4,                comment: "显示顺序(>=0)"
    t.integer  "store_id",   limit: 4,                comment: "关联店铺"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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
    t.decimal  "discount",                 precision: 10, scale: 2, default: 0.0, null: false, comment: "抵扣金额"
    t.datetime "activated_date",                                                  null: false, comment: "生效日期"
    t.datetime "expired_date",                                                    null: false, comment: "失效日期"
    t.integer  "user_id",        limit: 4,                                                     comment: "关联用户"
    t.integer  "status",         limit: 4,                                        null: false, comment: "优惠券状态"
    t.decimal  "least_price",              precision: 10, scale: 2, default: 0.0, null: false, comment: "最低起用价"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "order_id",       limit: 4,                                                     comment: "订单关联coupon"
  end

  create_table "expressers", force: :cascade do |t|
    t.string   "name",       limit: 255,                    null: false, comment: "快递员名字"
    t.string   "phone",      limit: 255,                    null: false, comment: "手机号"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "password",   limit: 255, default: "123456",              comment: "密码"
  end

  create_table "expresses", force: :cascade do |t|
    t.integer  "expresser_id", limit: 4,              comment: "快递员"
    t.integer  "order_id",     limit: 4,              comment: "关联订单"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "frozen_coupons", force: :cascade do |t|
    t.integer  "authorization_id", limit: 4,                                                     comment: "关联第三方登录(微信)"
    t.decimal  "discount",                   precision: 10, scale: 2, default: 0.0, null: false, comment: "抵扣金额"
    t.datetime "activated_date",                                                    null: false, comment: "生效日期"
    t.datetime "expired_date",                                                      null: false, comment: "失效日期"
    t.decimal  "least_price",                precision: 10, scale: 2, default: 0.0, null: false, comment: "最低起用价"
    t.integer  "coupon_id",        limit: 4,                                                     comment: "关联优惠券"
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.integer  "red_pack_id",      limit: 4,                                                     comment: "暂存优惠券属于某个红包"
  end

  create_table "managers", force: :cascade do |t|
    t.string   "phone",                  limit: 255, default: "", null: false, comment: "手机号"
    t.integer  "campus_id",              limit: 4,                             comment: "所属校区"
    t.boolean  "write",                                                        comment: "修改权限"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "managers", ["phone"], name: "index_managers_on_phone", unique: true, using: :btree
  add_index "managers", ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true, using: :btree

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
    t.decimal  "pay_price",                      precision: 10, scale: 2, default: 0.0,              comment: "实际支付金额"
    t.decimal  "service_price",                  precision: 10, scale: 2, default: 0.0,              comment: "服务费用"
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
    t.integer  "status",        limit: 4,   default: 1,      null: false
    t.string   "pinyin",        limit: 255
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "month_sale",    limit: 4,   default: 23
    t.integer  "category_id",   limit: 4,                                 comment: "关联分类"
  end

  create_table "red_packs", force: :cascade do |t|
    t.datetime "expired_at",           null: false, comment: "过期时间"
    t.integer  "user_id",    limit: 4, null: false, comment: "关联用户"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "order_id",   limit: 4,              comment: "红包关联订单"
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
    t.integer  "stock_per_day", limit: 4,                            default: 10,  null: false, comment: "订单每日更新的库存"
    t.decimal  "cost",                      precision: 10, scale: 2, default: 0.0,              comment: "成本价"
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
    t.integer  "boost",          limit: 4,     default: 0,      null: false, comment: "店铺权重"
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

  create_table "suit_specifications", force: :cascade do |t|
    t.integer  "suit_id",          limit: 4,              comment: "关联套餐"
    t.integer  "specification_id", limit: 4,              comment: "关联规格"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "suits", force: :cascade do |t|
    t.integer  "campus_id",  limit: 4,                                                       comment: "关联学校"
    t.decimal  "price",                  precision: 10, scale: 2, default: 0.0, null: false, comment: "总价"
    t.decimal  "discount",               precision: 10, scale: 2, default: 0.0, null: false, comment: "折扣(元)"
    t.integer  "status",     limit: 4,                            default: 0,   null: false, comment: "状态"
    t.string   "name",       limit: 255,                                                     comment: "名称"
    t.string   "desc",       limit: 255,                                                     comment: "描述"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone",      limit: 255,                                                null: false
    t.string   "password",   limit: 255,   default: "e10adc3949ba59abbe56e057f20f883e", null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.text     "avatar",     limit: 65535,                                                           comment: "用户头像"
  end

end
