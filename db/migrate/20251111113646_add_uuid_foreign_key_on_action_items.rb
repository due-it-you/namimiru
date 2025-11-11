class AddUuidForeignKeyOnActionItems < ActiveRecord::Migration[7.2]
  def change
    add_column :action_items, :action_tag_uuid, :uuid
    
    ActionItem.reset_column_information
    ActionItem.find_each do |rec|
      rec.update_column(:action_tag_uuid, ActionTag.find(rec.action_tag_id).uuid)
    end

    change_column_null :action_items, :action_tag_uuid, false
  end
end
