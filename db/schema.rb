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

ActiveRecord::Schema.define(version: 20150425154748) do

  create_table "actions", force: :cascade do |t|
    t.integer "recipient_starting_damage", limit: 4
    t.integer "recipient_ending_damage",   limit: 4
    t.string  "type",                      limit: 255
    t.integer "location_id",               limit: 4
    t.integer "day_id",                    limit: 4
  end

  create_table "actions_combatants", force: :cascade do |t|
    t.integer "action_id",    limit: 4
    t.integer "combatant_id", limit: 4
  end

  create_table "activity_checks", force: :cascade do |t|
    t.datetime "opens_on"
    t.datetime "closes_on"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "games",      limit: 4
  end

  create_table "activity_checks_characters", force: :cascade do |t|
    t.integer "character_id",      limit: 4
    t.integer "activity_check_id", limit: 4
  end

  create_table "characters", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "first_name",        limit: 255
    t.string   "last_name",         limit: 255
    t.string   "bio_thread",        limit: 255
    t.string   "home_area",         limit: 255
    t.string   "gender",            limit: 255
    t.string   "fc_first",          limit: 255
    t.string   "fc_last",           limit: 255
    t.boolean  "char_approved",     limit: 1
    t.boolean  "fc_approved",       limit: 1
    t.integer  "age",               limit: 4
    t.integer  "user_id",           limit: 4
    t.string   "special",           limit: 255
    t.integer  "reaping_check_id",  limit: 4
    t.integer  "activity_check_id", limit: 4
  end

  add_index "characters", ["activity_check_id"], name: "index_characters_on_activity_check_id", using: :btree
  add_index "characters", ["reaping_check_id"], name: "index_characters_on_reaping_check_id", using: :btree

  create_table "characters_reaping_checks", force: :cascade do |t|
    t.integer "character_id",     limit: 4
    t.integer "reaping_check_id", limit: 4
  end

  create_table "combatants", force: :cascade do |t|
    t.string   "type",            limit: 255
    t.string   "name",            limit: 255
    t.integer  "damage",          limit: 4
    t.integer  "hp",              limit: 4
    t.boolean  "has_fire",        limit: 1
    t.integer  "water_days",      limit: 4
    t.integer  "food_days",       limit: 4
    t.boolean  "poisoned",        limit: 1
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "active_location", limit: 4
  end

  create_table "games", force: :cascade do |t|
    t.integer "number", limit: 4
  end

  create_table "inventory_delta", force: :cascade do |t|
    t.integer "action_id",    limit: 4
    t.integer "item_id",      limit: 4
    t.integer "combatant_id", limit: 4
    t.string  "change",       limit: 255
  end

  create_table "items", force: :cascade do |t|
    t.string  "type",            limit: 255
    t.string  "name",            limit: 255
    t.integer "damage",          limit: 4
    t.integer "hp",              limit: 4
    t.integer "area",            limit: 4
    t.boolean "full",            limit: 1
    t.integer "uses",            limit: 4
    t.integer "damage_healed",   limit: 4
    t.boolean "poisoned",        limit: 1
    t.boolean "purified",        limit: 1
    t.string  "weapon_class",    limit: 255
    t.integer "active_location", limit: 4
  end

  create_table "locations", force: :cascade do |t|
    t.boolean "open",      limit: 1
    t.integer "closed_on", limit: 4
  end

  create_table "reaping_checks", force: :cascade do |t|
    t.datetime "opens_on"
    t.datetime "closes_on"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "games",      limit: 4
  end

  create_table "stations", force: :cascade do |t|
    t.boolean "combat",       limit: 1
    t.string  "station_name", limit: 255
    t.integer "combatant_id", limit: 4
  end

  create_table "tds", force: :cascade do |t|
    t.integer "action_id",    limit: 4
    t.integer "combatant_id", limit: 4
    t.integer "td_counter",   limit: 4
    t.boolean "active",       limit: 1
  end

  create_table "tesseras", force: :cascade do |t|
    t.integer  "number",           limit: 4
    t.boolean  "approved",         limit: 1
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "character_id",     limit: 4
    t.integer  "reaping_check_id", limit: 4
    t.integer  "previous_number",  limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "username",                    limit: 255
    t.string   "display_name",                limit: 255
    t.string   "characters",                  limit: 255
    t.string   "group",                       limit: 255
    t.string   "email",                       limit: 255
    t.string   "password_digest",             limit: 255
    t.boolean  "email_verified",              limit: 1
    t.string   "email_token",                 limit: 255
    t.string   "password_reset_token",        limit: 255
    t.datetime "password_reset_token_expiry"
  end

  add_foreign_key "characters", "activity_checks"
  add_foreign_key "characters", "reaping_checks"
end
