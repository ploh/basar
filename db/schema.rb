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

ActiveRecord::Schema.define(version: 20160428201001) do

  create_table "activities", force: :cascade do |t|
    t.integer  "seller_id",                   null: false
    t.integer  "task_id",                     null: false
    t.float    "planned_count", default: 0.0, null: false
    t.float    "actual_count",  default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["seller_id"], name: "index_activities_on_seller_id"
  add_index "activities", ["task_id", "seller_id"], name: "index_activities_on_task_id_and_seller_id", unique: true
  add_index "activities", ["task_id"], name: "index_activities_on_task_id"

  create_table "items", force: :cascade do |t|
    t.integer  "seller_id"
    t.decimal  "price",          precision: 6, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
  end

  add_index "items", ["seller_id"], name: "index_items_on_seller_id"
  add_index "items", ["transaction_id"], name: "index_items_on_transaction_id"

  create_table "sellers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "number"
    t.string   "initials",   limit: 255
    t.decimal  "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "sellers", ["user_id"], name: "index_sellers_on_user_id"

  create_table "tasks", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "sort_key"
    t.float    "weight"
    t.integer  "kind"
    t.integer  "limit"
    t.boolean  "only_d"
    t.boolean  "must_d"
  end

  add_index "tasks", ["sort_key"], name: "index_tasks_on_sort_key"

  create_table "transactions", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_key"
    t.integer  "user_id"
  end

  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
    t.integer  "seller_model"
    t.string   "first_name",                         default: "", null: false
    t.string   "last_name",                          default: "", null: false
    t.integer  "seller_number"
    t.string   "initials"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["seller_number"], name: "index_users_on_seller_number"
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end
