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

ActiveRecord::Schema.define(version: 20150720220740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_checks", force: :cascade do |t|
    t.datetime "opens_on"
    t.datetime "closes_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "games"
  end

  create_table "activity_checks_characters", force: :cascade do |t|
    t.integer "character_id"
    t.integer "activity_check_id"
  end

  create_table "attacks", force: :cascade do |t|
    t.string  "text"
    t.string  "armor_area"
    t.float   "damage"
    t.integer "attack_code"
  end

  create_table "characters", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "bio_thread"
    t.string   "home_area"
    t.string   "gender"
    t.string   "fc_first"
    t.string   "fc_last"
    t.boolean  "char_approved"
    t.boolean  "fc_approved"
    t.integer  "age"
    t.integer  "user_id"
    t.string   "special"
    t.integer  "reaping_check_id"
    t.integer  "activity_check_id"
    t.boolean  "fc_flagged"
    t.string   "fc_flag"
    t.boolean  "char_flagged"
    t.string   "char_flag"
    t.integer  "shared_fc_owner_id"
    t.boolean  "is_dead"
    t.boolean  "is_tribute"
    t.integer  "games_number"
  end

  add_index "characters", ["activity_check_id"], name: "index_characters_on_activity_check_id", using: :btree
  add_index "characters", ["reaping_check_id"], name: "index_characters_on_reaping_check_id", using: :btree

  create_table "characters_reaping_checks", force: :cascade do |t|
    t.integer "character_id"
    t.integer "reaping_check_id"
  end

  create_table "reaping_checks", force: :cascade do |t|
    t.datetime "opens_on"
    t.datetime "closes_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "games"
  end

  create_table "tesseras", force: :cascade do |t|
    t.integer  "number"
    t.boolean  "approved"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "character_id"
    t.integer  "reaping_check_id"
    t.integer  "previous_number"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "username"
    t.string   "display_name"
    t.string   "characters"
    t.string   "group"
    t.string   "email"
    t.string   "password_digest"
  end

  add_foreign_key "characters", "activity_checks"
  add_foreign_key "characters", "reaping_checks"
end
