class AddUserUuidForeignKey < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_records,   :user_uuid,      :uuid
    add_column :action_items,    :user_uuid,      :uuid
    add_column :action_tags,     :user_uuid,      :uuid
    add_column :social_profiles, :user_uuid,      :uuid
    add_column :care_relations,  :supported_uuid, :uuid
    add_column :care_relations,  :supporter_uuid, :uuid

    Rails.logger.info("STEP1 start daily_records")
    begin
      DailyRecord.reset_column_information
      DailyRecord.find_each do |r|
        uuid = User.unscoped.where(id: r.user_id).pick(:uuid)
        next unless uuid
        r.update_columns(user_uuid: uuid)
      end
      Rails.logger.info("STEP1 end daily_records")
    rescue => e
      Rails.logger.error("STEP1 FAIL #{e.class}: #{e.message}")
      raise
    end

    Rails.logger.info("STEP2 start action_items")
    begin
      ActionItem.reset_column_information
      ActionItem.find_each do |r|
        uuid = User.unscoped.where(id: r.user_id).pick(:uuid)
        next unless uuid
        r.update_columns(user_uuid: uuid)
      end
      Rails.logger.info("STEP2 end action_items")
    rescue => e
      Rails.logger.error("STEP2 FAIL #{e.class}: #{e.message}")
      raise
    end

    Rails.logger.info("STEP3 start action_tags")
    begin
      ActionTag.reset_column_information
      ActionTag.find_each do |r|
        uuid = User.unscoped.where(id: r.user_id).pick(:uuid)
        next unless uuid
        r.update_columns(user_uuid: uuid)
      end
      Rails.logger.info("STEP3 end action_tags")
    rescue => e
      Rails.logger.error("STEP3 FAIL #{e.class}: #{e.message}")
      raise
    end

    Rails.logger.info("STEP4 start social_profiles")
    begin
      SocialProfile.reset_column_information
      SocialProfile.find_each do |r|
        next unless r.user_id
        uuid = User.unscoped.where(id: r.user_id).pick(:uuid)
        next unless uuid
        r.update_columns(user_uuid: uuid)
      end
      Rails.logger.info("STEP4 end social_profiles")
    rescue => e
      Rails.logger.error("STEP4 FAIL #{e.class}: #{e.message}")
      raise
    end

    Rails.logger.info("STEP5 start care_relations")
    begin
      CareRelation.reset_column_information
      CareRelation.find_each do |r|
        if r.supported_id
          sup = User.unscoped.where(id: r.supported_id).pick(:uuid)
          r.update_columns(supported_uuid: sup) if sup
        end
        if r.supporter_id
          spr = User.unscoped.where(id: r.supporter_id).pick(:uuid)
          r.update_columns(supporter_uuid: spr) if spr
        end
      end
      Rails.logger.info("STEP5 end care_relations")
    rescue => e
      Rails.logger.error("STEP5 FAIL #{e.class}: #{e.message}")
      raise
    end

    change_column_null :daily_records,   :user_uuid,      false
    change_column_null :action_items,    :user_uuid,      false
    change_column_null :action_tags,     :user_uuid,      false
    change_column_null :social_profiles, :user_uuid,      false
    change_column_null :care_relations,  :supported_uuid, false
    change_column_null :care_relations,  :supporter_uuid, false
  end
end
