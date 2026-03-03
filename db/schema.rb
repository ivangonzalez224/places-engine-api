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

ActiveRecord::Schema[7.1].define(version: 2026_03_03_123003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.string "image_url"
    t.string "user_name"
    t.string "user_pic"
    t.bigint "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_comments_on_place_id"
  end

  create_table "markers", force: :cascade do |t|
    t.decimal "lat"
    t.decimal "lng"
    t.string "city_code"
    t.bigint "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_code"], name: "index_markers_on_city_code"
    t.index ["place_id"], name: "index_markers_on_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.integer "place_type", default: 0
    t.boolean "is_vegan", default: false
    t.decimal "rating", precision: 3, scale: 2
    t.jsonb "schedule", default: {}
    t.jsonb "links", default: {}
    t.string "price_range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "places"
  add_foreign_key "markers", "places"
end
