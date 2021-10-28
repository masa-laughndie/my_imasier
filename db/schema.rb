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

ActiveRecord::Schema.define(version: 2021_10_27_133200) do

  create_table "contractings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "license_id", null: false
    t.integer "payment_method_id", null: false
    t.integer "price", null: false
    t.datetime "contracted_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["license_id"], name: "index_contractings_on_license_id"
    t.index ["payment_method_id"], name: "index_contractings_on_payment_method_id"
    t.index ["user_id"], name: "index_contractings_on_user_id"
  end

  create_table "download_rights", force: :cascade do |t|
    t.integer "license_id", null: false
    t.datetime "valid_from", null: false
    t.datetime "valid_to", null: false
    t.integer "right_count", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["license_id"], name: "index_download_rights_on_license_id"
  end

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

  create_table "downloadings", force: :cascade do |t|
    t.integer "download_right_id", null: false
    t.integer "license_seat_id", null: false
    t.integer "item_id"
    t.datetime "downloaded_at"
    t.boolean "download_right_exercise", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["download_right_id"], name: "index_downloadings_on_download_right_id"
    t.index ["license_seat_id"], name: "index_downloadings_on_license_seat_id"
  end

  create_table "license_renewal_paths", force: :cascade do |t|
    t.integer "from_license_id", null: false
    t.integer "to_license_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_license_id"], name: "index_license_renewal_paths_on_from_license_id"
    t.index ["to_license_id"], name: "index_license_renewal_paths_on_to_license_id"
  end

  create_table "license_renewal_reservations", force: :cascade do |t|
    t.integer "license_id", null: false
    t.integer "renewal_plan_id", null: false
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["license_id"], name: "index_license_renewal_reservations_on_license_id", unique: true
    t.index ["renewal_plan_id"], name: "index_license_renewal_reservations_on_renewal_plan_id"
  end

  create_table "license_seats", force: :cascade do |t|
    t.integer "license_id", null: false
    t.integer "user_id", null: false
    t.datetime "assigned_at", null: false
    t.datetime "unassigned_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["license_id"], name: "index_license_seats_on_license_id"
    t.index ["user_id"], name: "index_license_seats_on_user_id"
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

  create_table "payment_methods", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  add_foreign_key "contractings", "licenses"
  add_foreign_key "contractings", "payment_methods"
  add_foreign_key "contractings", "users"
  add_foreign_key "download_rights", "licenses"
  add_foreign_key "download_rights_packings", "download_rights_grantings"
  add_foreign_key "download_rights_packings", "plans"
  add_foreign_key "downloadings", "download_rights"
  add_foreign_key "downloadings", "license_seats"
  add_foreign_key "license_renewal_paths", "licenses", column: "from_license_id"
  add_foreign_key "license_renewal_paths", "licenses", column: "to_license_id"
  add_foreign_key "license_renewal_reservations", "licenses"
  add_foreign_key "license_renewal_reservations", "plans", column: "renewal_plan_id"
  add_foreign_key "license_seats", "licenses"
  add_foreign_key "license_seats", "users"
  add_foreign_key "licenses", "plans"
  add_foreign_key "licenses", "users"
end
