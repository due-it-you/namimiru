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

ActiveRecord::Schema[7.2].define(version: 2025_07_30_222848) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "user_role", ["unclear", "person_with_bipolar", "supporter"]

  create_table "users", force: :cascade do |t|
    t.string "line_user_id", null: false
    t.enum "role", default: "unclear", null: false, enum_type: "user_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_user_id"], name: "index_users_on_line_user_id", unique: true
  end
end
