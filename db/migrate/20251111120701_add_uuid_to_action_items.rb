class AddUuidToActionItems < ActiveRecord::Migration[7.2]
  def change
    add_column :action_items, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :action_items, :uuid, unique: true

    ActionItem.reset_column_information
    ActionItem.find_each { |rec| rec.update_column(:uuid, SecureRandom.uuid) }
  end
end
