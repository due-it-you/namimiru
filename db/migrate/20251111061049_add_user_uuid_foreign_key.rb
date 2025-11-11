class AddUserUuidForeignKey < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_records,   :user_uuid,      :uuid
    add_column :action_items,    :user_uuid,      :uuid
    add_column :action_tags,     :user_uuid,      :uuid
    add_column :social_profiles, :user_uuid,      :uuid
    add_column :care_relations,  :supported_uuid, :uuid
    add_column :care_relations,  :supporter_uuid, :uuid

    DailyRecord.reset_column_information
    DailyRecord.find_each do |record|
      record.update_column(:user_uuid, User.find(record.user_id).uuid)
    end

    ActionItem.reset_column_information
    ActionItem.find_each do |record|
      record.update_column(:user_uuid, User.find(record.user_id).uuid)
    end

    ActionTag.reset_column_information
    ActionTag.find_each do |record|
      record.update_column(:user_uuid, User.find(record.user_id).uuid)
    end

    SocialProfile.reset_column_information
    SocialProfile.find_each do |record|
      record.update_column(:user_uuid, User.find(record.user_id).uuid) if record.user_id
    end

    CareRelation.reset_column_information
    CareRelation.find_each do |record|
      record.update_column(:supported_uuid, User.find(record.supported_id).uuid) if record.supported_id
      record.update_column(:supporter_uuid, User.find(record.supporter_id).uuid) if record.supporter_id
    end

    change_column_null :daily_records,   :user_uuid,      false
    change_column_null :action_items,    :user_uuid,      false
    change_column_null :action_tags,     :user_uuid,      false
    change_column_null :social_profiles, :user_uuid,      false
    change_column_null :care_relations,  :supported_uuid, false
    change_column_null :care_relations,  :supporter_uuid, false
  end
end
