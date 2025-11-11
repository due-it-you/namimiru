class AddUserUuidIndex < ActiveRecord::Migration[7.2]
  def change
    add_index :daily_records, :user_uuid
    add_index :action_items, :user_uuid
    add_index :action_tags, :user_uuid
    add_index :social_profiles, :user_uuid
    add_index :care_relations, :supported_uuid
    add_index :care_relations, :supporter_uuid
    add_index :care_relations, [:supported_uuid, :supporter_uuid], unique: true
  end
end
