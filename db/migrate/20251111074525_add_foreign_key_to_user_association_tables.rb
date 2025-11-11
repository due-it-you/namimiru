class AddForeignKeyToUserAssociationTables < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :daily_records, :users, column: :user_uuid, primary_key: :uuid
    add_foreign_key :action_items, :users, column: :user_uuid, primary_key: :uuid
    add_foreign_key :action_tags, :users, column: :user_uuid, primary_key: :uuid
    add_foreign_key :social_profiles, :users, column: :user_uuid, primary_key: :uuid
    add_foreign_key :care_relations, :users, column: :supported_uuid, primary_key: :uuid
    add_foreign_key :care_relations, :users, column: :supporter_uuid, primary_key: :uuid
  end
end
