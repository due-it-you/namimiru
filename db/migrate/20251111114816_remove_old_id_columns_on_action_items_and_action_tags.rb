class RemoveOldIdColumnsOnActionItemsAndActionTags < ActiveRecord::Migration[7.2]
  def change
    remove_column :action_items, :action_tag_id, :bigint
  end
end
