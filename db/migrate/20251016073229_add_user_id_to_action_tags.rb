class AddUserIdToActionTags < ActiveRecord::Migration[7.2]
  def change
    add_reference :action_tags, :user, null:false, foreign_key: true
  end
end
