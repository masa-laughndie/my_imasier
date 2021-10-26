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

ActiveRecord::Schema.define(version: 2021_10_26_095144) do

  create_table "download_rights_grantings", force: :cascade do |t|
    t.integer "right_count", null: false
    t.integer "interval_number", null: false
    t.string "interval_unit", null: false
    t.integer "valid_duration_number", null: false
    t.string "valid_duration_unit", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "download_rights_packings", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.integer "download_rights_granting_id", null: false
    t.integer "grant_order", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["download_rights_granting_id"], name: "index_download_rights_packings_on_download_rights_granting_id"
    t.index ["plan_id", "download_rights_granting_id", "grant_order"], name: "index_download_rights_packings_for_single_order", unique: true
    t.index ["plan_id"], name: "index_download_rights_packings_on_plan_id"
  end

  create_table "licenses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "plan_id", null: false
    t.datetime "exercisable_from", null: false
    t.datetime "exercisable_to", null: false
    t.string "download_right_flexible_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_licenses_on_plan_id"
    t.index ["user_id"], name: "index_licenses_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.integer "price", null: false
    t.integer "contract_duration_number", null: false
    t.string "contract_duration_unit", null: false
    t.integer "seats_count", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "download_rights_packings", "download_rights_grantings"
  add_foreign_key "download_rights_packings", "plans"
  add_foreign_key "licenses", "plans"
  add_foreign_key "licenses", "users"
end
