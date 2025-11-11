class RemoveUserIdColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :daily_records, :user_id, :bigint
    remove_column :action_items, :user_id, :bigint
    remove_column :action_tags, :user_id, :bigint
    remove_column :social_profiles, :user_id, :bigint
    remove_column :care_relations, :supported_id, :bigint
    remove_column :care_relations, :supporter_id, :bigint
  end
end
