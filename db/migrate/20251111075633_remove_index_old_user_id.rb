class RemoveIndexOldUserId < ActiveRecord::Migration[7.2]
  def change
    remove_index :action_items, name: "index_action_items_on_user_id"
    remove_index :action_tags, name: "index_action_tags_on_user_id"
    remove_index :care_relations, name: "index_care_relations_on_supported_id_and_supporter_id"
    remove_index :care_relations, name: "index_care_relations_on_supported_id"
    remove_index :care_relations, name: "index_care_relations_on_supporter_id"
    remove_index :daily_records, name: "index_daily_records_on_user_id"
    remove_index :social_profiles, name: "index_social_profiles_on_user_id"
  end
end
