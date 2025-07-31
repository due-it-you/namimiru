class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_enum :user_role, [ "unclear", "person_with_bipolar", "supporter" ]

    create_table :users do |t|
      t.string :line_user_id, null: false, index: { unique: true }
      t.enum :role, enum_type: "user_role", default: "unclear", null: false
      t.timestamps
    end
  end
end
