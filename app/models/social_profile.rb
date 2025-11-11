class SocialProfile < ApplicationRecord
  belongs_to :user, primary_key: :uuid, foreign_key: :user_uuid

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
end
