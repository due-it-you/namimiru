class AddUuidToUsers < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto'
    add_column :users, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :users, :uuid, unique: true
    User.reset_column_information
    User.find_each { |user| user.update_column(:uuid, SecureRandom.uuid) }
  end
end
