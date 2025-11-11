class RemoveOldUserForeignKey < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :daily_records, :users
    remove_foreign_key :action_items, :users
    remove_foreign_key :action_tags, :users
    remove_foreign_key :social_profiles, :users
    remove_foreign_key :care_relations, column: :supported_id
    remove_foreign_key :care_relations, column: :supporter_id
  end
end
