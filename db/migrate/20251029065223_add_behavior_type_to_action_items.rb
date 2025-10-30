class AddBehaviorTypeToActionItems < ActiveRecord::Migration[7.2]
  def change
    add_column :action_items, :behavior_type, :integer, default: 0, null: false
  end
end
