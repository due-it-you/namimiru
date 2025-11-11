class ChangePrimaryKeyOnSocialProfiles < ActiveRecord::Migration[7.2]
  def change
    execute 'ALTER TABLE social_profiles DROP CONSTRAINT social_profiles_pkey;'
    execute 'ALTER TABLE social_profiles ADD PRIMARY KEY (uuid);'
  end
end
