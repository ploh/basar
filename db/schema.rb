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

ActiveRecord::Schema.define(version: 20130923191816) do

  create_table "items", force: true do |t|
    t.integer  "seller_id"
    t.decimal  "price",          precision: 6, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
  end

  add_index "items", ["seller_id"], name: "index_items_on_seller_id"
  add_index "items", ["transaction_id"], name: "index_items_on_transaction_id"

  create_table "sellers", force: true do |t|
    t.string   "name"
    t.integer  "number"
    t.string   "initials"
    t.decimal  "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
