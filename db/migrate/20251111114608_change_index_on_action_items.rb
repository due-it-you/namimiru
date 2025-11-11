class ChangeIndexOnActionItems < ActiveRecord::Migration[7.2]
  def change
    remove_index :action_items, name: "index_action_items_on_action_tag_id"
    add_index :action_items, :action_tag_uuid
  end
end
