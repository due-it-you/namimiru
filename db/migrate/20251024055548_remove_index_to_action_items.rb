class RemoveIndexToActionItems < ActiveRecord::Migration[7.2]
  def change
  end
  remove_index :action_tags, :name
end
