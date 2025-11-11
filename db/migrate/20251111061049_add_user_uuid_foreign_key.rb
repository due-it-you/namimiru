class AddUserUuidForeignKey < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_records,   :user_uuid,      :uuid
    add_column :action_items,    :user_uuid,      :uuid
    add_column :action_tags,     :user_uuid,      :uuid
    add_column :social_profiles, :user_uuid,      :uuid
    add_column :care_relations,  :supported_uuid, :uuid
    add_column :care_relations,  :supporter_uuid, :uuid

    # DailyRecord
    DailyRecord.reset_column_information
    DailyRecord.find_each do |record|
      user_uuid = User.unscoped.where(id: record.user_id).pick(:uuid)  # ← ここが肝
      next unless user_uuid
      record.update_columns(user_uuid: user_uuid)
    end

    # ActionItem
    ActionItem.reset_column_information
    ActionItem.find_each do |record|
      user_uuid = User.unscoped.where(id: record.user_id).pick(:uuid)
      next unless user_uuid
      record.update_columns(user_uuid: user_uuid)
    end

    # ActionTag
    ActionTag.reset_column_information
    ActionTag.find_each do |record|
      user_uuid = User.unscoped.where(id: record.user_id).pick(:uuid)
      next unless user_uuid
      record.update_columns(user_uuid: user_uuid)
    end

    # SocialProfile
    SocialProfile.reset_column_information
    SocialProfile.find_each do |record|
      next unless record.user_id
      user_uuid = User.unscoped.where(id: record.user_id).pick(:uuid)
      next unless user_uuid
      record.update_columns(user_uuid: user_uuid)
    end

    # CareRelation
    CareRelation.reset_column_information
    CareRelation.find_each do |record|
      if record.supported_id
        sup_uuid = User.unscoped.where(id: record.supported_id).pick(:uuid)
        record.update_columns(supported_uuid: sup_uuid) if sup_uuid
      end
      if record.supporter_id
        spr_uuid = User.unscoped.where(id: record.supporter_id).pick(:uuid)
        record.update_columns(supporter_uuid: spr_uuid) if spr_uuid
      end
    end

    change_column_null :daily_records,   :user_uuid,      false
    change_column_null :action_items,    :user_uuid,      false
    change_column_null :action_tags,     :user_uuid,      false
    change_column_null :social_profiles, :user_uuid,      false
    change_column_null :care_relations,  :supported_uuid, false
    change_column_null :care_relations,  :supporter_uuid, false
  end
end
