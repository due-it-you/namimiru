class CareRelation < ApplicationRecord
  belongs_to :supported, class_name: "User"
  belongs_to :supporter, class_name: "User"

  validates :supported_id, uniqueness: { scope: :supporter_id }
  validates :supported_id, comparison: { other_than: :supporter_id }
end
