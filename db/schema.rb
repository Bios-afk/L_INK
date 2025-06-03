# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_06_03_123016) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.float "longitude"
    t.float "latitude"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_bookings_on_artist_id"
    t.index ["client_id"], name: "index_bookings_on_client_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "message_feeds", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_message_feeds_on_artist_id"
    t.index ["client_id"], name: "index_message_feeds_on_client_id"
  end

  create_table "messages", force: :cascade do |t|
    t.boolean "read"
    t.string "body"
    t.bigint "message_feed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_feed_id"], name: "index_messages_on_message_feed_id"
  end

  create_table "quote_requests", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "artist_id", null: false
    t.jsonb "style", default: [], null: false
    t.jsonb "color", default: [], null: false
    t.string "size"
    t.jsonb "body_zone", default: [], null: false
    t.string "allergies"
    t.text "comments"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_quote_requests_on_artist_id"
    t.index ["client_id"], name: "index_quote_requests_on_client_id"
  end

  create_table "tattoo_categories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_tattoo_categories_on_category_id"
    t.index ["user_id"], name: "index_tattoo_categories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "bio"
    t.float "longitude"
    t.float "latitude"
    t.string "userable_type", null: false
    t.bigint "userable_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["userable_type", "userable_id"], name: "index_users_on_userable"
  end

  add_foreign_key "bookings", "artists"
  add_foreign_key "bookings", "clients"
  add_foreign_key "message_feeds", "artists"
  add_foreign_key "message_feeds", "clients"
  add_foreign_key "messages", "message_feeds"
  add_foreign_key "quote_requests", "artists"
  add_foreign_key "quote_requests", "clients"
  add_foreign_key "tattoo_categories", "categories"
  add_foreign_key "tattoo_categories", "users"
end
