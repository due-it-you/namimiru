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

ActiveRecord::Schema[7.2].define(version: 2025_11_11_112539) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_items", force: :cascade do |t|
    t.string "name", null: false
    t.integer "enabled_from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "action_tag_id"
    t.integer "behavior_type", default: 0, null: false
    t.uuid "user_uuid", null: false
    t.index ["action_tag_id"], name: "index_action_items_on_action_tag_id"
    t.index ["user_uuid"], name: "index_action_items_on_user_uuid"
  end

  create_table "action_tags", force: :cascade do |t|
    t.string "name", default: "未分類", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_uuid", null: false
    t.index ["user_uuid"], name: "index_action_tags_on_user_uuid"
  end

  create_table "care_relations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "supported_uuid", null: false
    t.uuid "supporter_uuid", null: false
    t.index ["supported_uuid", "supporter_uuid"], name: "index_care_relations_on_supported_uuid_and_supporter_uuid", unique: true
    t.index ["supported_uuid"], name: "index_care_relations_on_supported_uuid"
    t.index ["supporter_uuid"], name: "index_care_relations_on_supporter_uuid"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "subject", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "daily_records", primary_key: "uuid", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigserial "id", null: false
    t.integer "mood_score", null: false
    t.string "memo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_uneasy", default: false, null: false
    t.uuid "user_uuid", null: false
    t.index ["user_uuid"], name: "index_daily_records_on_user_uuid"
    t.index ["uuid"], name: "index_daily_records_on_uuid", unique: true
  end

  create_table "social_profiles", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_uuid", null: false
    t.index ["provider", "uid"], name: "index_social_profiles_on_provider_and_uid", unique: true
    t.index ["user_uuid"], name: "index_social_profiles_on_user_uuid"
  end

  create_table "users", primary_key: "uuid", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigserial "id", null: false
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
    t.string "invitee_role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "action_items", "action_tags"
  add_foreign_key "action_items", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "action_tags", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "care_relations", "users", column: "supported_uuid", primary_key: "uuid"
  add_foreign_key "care_relations", "users", column: "supporter_uuid", primary_key: "uuid"
  add_foreign_key "daily_records", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "social_profiles", "users", column: "user_uuid", primary_key: "uuid"
end
