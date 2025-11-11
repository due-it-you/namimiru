class CareRelation < ApplicationRecord
  belongs_to :supported, class_name: "User", primary_key: :uuid, foreign_key: :supported_uuid
  belongs_to :supporter, class_name: "User", primary_key: :uuid, foreign_key: :supporter_uuid

  validates :supported_uuid, uniqueness: { scope: :supporter_uuid }
  validates :supported_uuid, comparison: { other_than: :supporter_uuid }
end
