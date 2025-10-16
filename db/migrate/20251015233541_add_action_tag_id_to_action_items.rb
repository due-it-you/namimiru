class AddActionTagIdToActionItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :action_items, :action_tag, foreign_key: true
  end
end
