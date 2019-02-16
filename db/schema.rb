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

ActiveRecord::Schema.define(version: 2016_09_27_094000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "seller_id", null: false
    t.integer "task_id", null: false
    t.float "planned_count", default: 0.0, null: false
    t.float "actual_count", default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["seller_id"], name: "index_activities_on_seller_id"
    t.index ["task_id", "seller_id"], name: "index_activities_on_task_id_and_seller_id", unique: true
    t.index ["task_id"], name: "index_activities_on_task_id"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.integer "seller_id"
    t.decimal "price", precision: 6, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "transaction_id"
    t.index ["seller_id"], name: "index_items_on_seller_id"
    t.index ["transaction_id"], name: "index_items_on_transaction_id"
  end

  create_table "sellers", id: :serial, force: :cascade do |t|
    t.integer "number"
    t.string "initials"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.integer "model"
    t.index ["user_id"], name: "index_sellers_on_user_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "sort_key"
    t.float "weight"
    t.integer "kind"
    t.integer "limit"
    t.boolean "only_d"
    t.boolean "must_d"
    t.boolean "must_e"
    t.index ["sort_key"], name: "index_tasks_on_sort_key"
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "client_key"
    t.integer "user_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "role"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "old_number"
    t.string "old_initials"
    t.integer "wish_a"
    t.integer "wish_b"
    t.integer "wish_c"
    t.float "weighting"
    t.boolean "cake"
    t.boolean "help"
    t.string "remark"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
