class AddUuidToActionTags < ActiveRecord::Migration[7.2]
  def change
    add_column :action_tags, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :action_tags, :uuid, unique: true

    ActionTag.reset_column_information
    ActionTag.find_each { |record| record.update_column(:uuid, SecureRandom.uuid) }
  end
end
