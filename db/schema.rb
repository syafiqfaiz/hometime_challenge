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

ActiveRecord::Schema.define(version: 2022_05_19_110244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_numbers"
    t.text "additional_phone_numbers", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.string "reservation_code"
    t.integer "reservation_origin"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "status"
    t.integer "adult_guest", default: 0
    t.integer "children_guest", default: 0
    t.integer "infant_guest", default: 0
    t.integer "nights", default: 0
    t.json "original_payload"
    t.integer "total_price_cents", default: 0, null: false
    t.string "total_price_currency", default: "USD", null: false
    t.integer "payout_price_cents", default: 0, null: false
    t.string "payout_price_currency", default: "USD", null: false
    t.integer "security_price_cents", default: 0, null: false
    t.string "security_price_currency", default: "USD", null: false
    t.integer "guest_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reservation_code"], name: "index_reservations_on_reservation_code"
  end

end
