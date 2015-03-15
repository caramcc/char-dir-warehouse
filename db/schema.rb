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

ActiveRecord::Schema.define(version: 20150315160558) do

  create_table "characters", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "bio_thread",    limit: 255
    t.string   "home_area",     limit: 255
    t.string   "gender",        limit: 255
    t.string   "fc_first",      limit: 255
    t.string   "fc_last",       limit: 255
    t.boolean  "char_approved", limit: 1
    t.boolean  "fc_approved",   limit: 1
    t.integer  "age",           limit: 4
    t.integer  "user_id",       limit: 4
    t.string   "special",       limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "username",        limit: 255
    t.string   "display_name",    limit: 255
    t.string   "characters",      limit: 255
    t.string   "group",           limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
  end

end
