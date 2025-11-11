class AddUuidToSocialProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :social_profiles, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :social_profiles, :uuid, unique: true

    SocialProfile.reset_column_information
    SocialProfile.find_each { |rec| rec.update_column(:uuid, SecureRandom.uuid) }
  end
end
