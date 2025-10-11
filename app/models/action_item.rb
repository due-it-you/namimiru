class ActionItem < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :enabled_from, presence: true, numericality: { in: -5..5 }
end
