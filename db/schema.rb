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

ActiveRecord::Schema[7.2].define(version: 2025_09_27_080106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "care_relations", force: :cascade do |t|
    t.bigint "supported_id"
    t.bigint "supporter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supported_id", "supporter_id"], name: "index_care_relations_on_supported_id_and_supporter_id", unique: true
    t.index ["supported_id"], name: "index_care_relations_on_supported_id"
    t.index ["supporter_id"], name: "index_care_relations_on_supporter_id"
  end

  create_table "daily_records", force: :cascade do |t|
    t.integer "mood_score", null: false
    t.string "memo", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_daily_records_on_user_id"
  end

  create_table "social_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_social_profiles_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_social_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "is_guest", default: false, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.string "remember_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "care_relations", "users", column: "supported_id"
  add_foreign_key "care_relations", "users", column: "supporter_id"
  add_foreign_key "daily_records", "users"
  add_foreign_key "social_profiles", "users"
end
