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

ActiveRecord::Schema.define(version: 20190314033226) do

  create_table "aliases", force: :cascade do |t|
    t.string "name"
    t.string "command"
    t.integer "location_id"
    t.integer "operating_system_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["location_id"], name: "index_aliases_on_location_id"
  end

  create_table "aliases_categories", id: false, force: :cascade do |t|
    t.integer "alias_id", null: false
    t.integer "category_id", null: false
    t.index ["alias_id"], name: "index_aliases_categories_on_alias_id"
    t.index ["category_id"], name: "index_aliases_categories_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "categories_environments", id: false, force: :cascade do |t|
    t.integer "environment_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_categories_environments_on_category_id"
    t.index ["environment_id"], name: "index_categories_environments_on_environment_id"
  end

  create_table "categories_functions", id: false, force: :cascade do |t|
    t.integer "function_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_categories_functions_on_category_id"
    t.index ["function_id"], name: "index_categories_functions_on_function_id"
  end

  create_table "categories_hotkeys", id: false, force: :cascade do |t|
    t.integer "hotkey_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_categories_hotkeys_on_category_id"
    t.index ["hotkey_id"], name: "index_categories_hotkeys_on_hotkey_id"
  end

  create_table "categories_startups", id: false, force: :cascade do |t|
    t.integer "startup_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_categories_startups_on_category_id"
    t.index ["startup_id"], name: "index_categories_startups_on_startup_id"
  end

  create_table "environments", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.integer "location_id"
    t.integer "operating_system_id"
    t.index ["location_id"], name: "index_environments_on_location_id"
  end

  create_table "functions", force: :cascade do |t|
    t.string "name"
    t.string "body"
    t.integer "location_id"
    t.integer "operating_system_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["location_id"], name: "index_functions_on_location_id"
  end

  create_table "histories", force: :cascade do |t|
    t.string "command"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.index ["location_id"], name: "index_histories_on_location_id"
  end

  create_table "hotkey_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "hotkeys", force: :cascade do |t|
    t.string "key"
    t.string "command"
    t.integer "location_id"
    t.boolean "executes"
    t.string "name"
    t.integer "hotkey_type_id"
    t.integer "parent_id"
    t.integer "operating_system_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "full_name"
    t.index ["location_id"], name: "index_hotkeys_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "path"
    t.string "host"
  end

  create_table "operating_systems", force: :cascade do |t|
    t.string "name"
  end

  create_table "startups", force: :cascade do |t|
    t.string "name"
    t.string "executable_id"
    t.integer "location_id"
    t.integer "operating_system_id"
    t.integer "order"
    t.index ["location_id"], name: "index_startups_on_location_id"
    t.index ["operating_system_id"], name: "index_startups_on_operating_system_id"
  end

end
