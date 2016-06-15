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

ActiveRecord::Schema.define(version: 20160314173230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_documents", force: :cascade do |t|
    t.integer  "store_setting_id"
    t.string   "ic_passport"
    t.string   "bank"
    t.string   "business"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "account_documents", ["store_setting_id"], name: "index_account_documents_on_store_setting_id", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "bg_cover_img"
    t.string   "description"
    t.string   "slug"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "m_title"
    t.text     "m_desc"
    t.text     "m_key"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "invoice_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_details", force: :cascade do |t|
    t.integer  "invoice_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.text     "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "contact_details", ["invoice_id"], name: "index_contact_details_on_invoice_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "amount_cents"
    t.string   "currency"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "product_id"
    t.date     "booking_date"
    t.string   "billing_country"
    t.integer  "amount_cents"
    t.text     "variants"
    t.integer  "payment_type"
    t.integer  "card_type"
    t.integer  "valid_month"
    t.integer  "valid_year"
    t.string   "security_code"
    t.string   "currency"
    t.integer  "status",                    limit: 2,                         default: 0
    t.string   "token"
    t.string   "payer_id"
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.integer  "user_id"
    t.integer  "merchant_status",           limit: 2,                         default: 0
    t.boolean  "is_reward_credit",                                            default: false
    t.decimal  "reward_credit",                       precision: 5, scale: 2
    t.integer  "coupon_id"
    t.decimal  "coupon_amounts",                      precision: 5, scale: 2, default: 0.0
    t.decimal  "billed",                              precision: 8, scale: 2, default: 0.0
    t.integer  "product_discount",                                            default: 100
    t.boolean  "is_sent_email_unprocessed",                                   default: true
  end

  add_index "invoices", ["product_id"], name: "index_invoices_on_product_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "country",    default: "Malaysia"
    t.string   "state"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "product_attachments", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_attachments", ["product_id"], name: "index_product_attachments_on_product_id", using: :btree

  create_table "product_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_reviews", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "rating_stars", limit: 2, default: 0
  end

  add_index "product_reviews", ["product_id"], name: "index_product_reviews_on_product_id", using: :btree
  add_index "product_reviews", ["user_id"], name: "index_product_reviews_on_user_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "payment_type",        limit: 2
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "product_category_id"
    t.integer  "location_id"
    t.text     "description"
    t.text     "highlight"
    t.integer  "price_cents"
    t.integer  "zip"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "address"
    t.string   "apt"
    t.integer  "refund_day"
    t.string   "currency"
    t.integer  "refund_percent"
    t.integer  "refundable",          limit: 2, default: 0
    t.integer  "step",                limit: 2, default: 0
    t.integer  "discount",                      default: 0
    t.string   "slug"
    t.integer  "status",              limit: 2, default: 1
    t.integer  "verification",        limit: 2, default: 0
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "profile_documents", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "document"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profile_documents", ["profile_id"], name: "index_profile_documents_on_profile_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.date     "birthday"
    t.integer  "gender",       limit: 2
    t.text     "bio"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "phone_number"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "store_images", force: :cascade do |t|
    t.integer  "store_setting_id"
    t.string   "store_img"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "store_images", ["store_setting_id"], name: "index_store_images_on_store_setting_id", using: :btree

  create_table "store_settings", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "store_name"
    t.string   "store_username"
    t.string   "phone_number"
    t.string   "store_img"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "country"
    t.string   "paypal_email"
    t.string   "mobile_number"
    t.string   "website"
    t.integer  "merchant_type",  limit: 2, default: 0
    t.text     "know_us_text"
    t.string   "currency"
    t.string   "uuid"
  end

  add_index "store_settings", ["user_id"], name: "index_store_settings_on_user_id", using: :btree

  create_table "user_avatars", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_avatars", ["profile_id"], name: "index_user_avatars_on_profile_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "",    null: false
    t.string   "encrypted_password",               default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "provider"
    t.string   "uid"
    t.integer  "status",                 limit: 2, default: 0
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                default: 0
    t.integer  "reward_credit",                    default: 0
    t.string   "fb_share_token"
    t.boolean  "is_fb_invited",                    default: false
    t.integer  "merchant_status",        limit: 2, default: 0
    t.integer  "super",                  limit: 2, default: 0
    t.string   "access_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "variants", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "name"
    t.integer  "price_cents"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "min_count"
    t.integer  "max_count"
  end

  add_index "variants", ["product_id"], name: "index_variants_on_product_id", using: :btree

end
