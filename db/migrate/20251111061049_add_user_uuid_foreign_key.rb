class AddUserUuidForeignKey < ActiveRecord::Migration[7.2]
  def up
    add_column :daily_records,   :user_uuid,      :uuid
    add_column :action_items,    :user_uuid,      :uuid
    add_column :action_tags,     :user_uuid,      :uuid
    add_column :social_profiles, :user_uuid,      :uuid
    add_column :care_relations,  :supported_uuid, :uuid
    add_column :care_relations,  :supporter_uuid, :uuid

    say "BF daily_records"
    execute <<~SQL
    UPDATE daily_records dr
    SET user_uuid = u.uuid
    FROM users u
    WHERE dr.user_uuid IS NULL
    AND dr.user_id = u.id;
    SQL

    say "BF action_items"
    execute <<~SQL
    UPDATE action_items ai
    SET user_uuid = u.uuid
    FROM users u
    WHERE ai.user_uuid IS NULL
    AND ai.user_id = u.id;
    SQL

    say "BF action_tags"
    execute <<~SQL
    UPDATE action_tags at
    SET user_uuid = u.uuid
    FROM users u
    WHERE at.user_uuid IS NULL
    AND at.user_id = u.id;
    SQL

    say "BF social_profiles"
    execute <<~SQL
    UPDATE social_profiles sp
    SET user_uuid = u.uuid
    FROM users u
    WHERE sp.user_uuid IS NULL
    AND sp.user_id = u.id;
    SQL

    say "BF care_relations.supported_uuid"
    execute <<~SQL
    UPDATE care_relations cr
    SET supported_uuid = u.uuid
    FROM users u
    WHERE cr.supported_uuid IS NULL
    AND cr.supported_id = u.id;
    SQL

    say "BF care_relations.supporter_uuid"
    execute <<~SQL
    UPDATE care_relations cr
    SET supporter_uuid = u.uuid
    FROM users u
    WHERE cr.supporter_uuid IS NULL
    AND cr.supporter_id = u.id;
    SQL

    change_column_null :daily_records,   :user_uuid,      false
    change_column_null :action_items,    :user_uuid,      false
    change_column_null :action_tags,     :user_uuid,      false
    change_column_null :social_profiles, :user_uuid,      false
    change_column_null :care_relations,  :supported_uuid, false
    change_column_null :care_relations,  :supporter_uuid, false
  end

  def down
    remove_column :daily_records,   :user_uuid
    remove_column :action_items,    :user_uuid
    remove_column :action_tags,     :user_uuid
    remove_column :social_profiles, :user_uuid
    remove_column :care_relations,  :supported_uuid
    remove_column :care_relations,  :supporter_uuid
  end
end
