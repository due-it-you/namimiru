class ActionItem < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :enabled_from, presence: true, numericality: { in: -5..5 }

  scope :capable, -> (mood_score) { where("enabled_from <= ?", mood_score.to_i) }
  scope :incapable, -> (mood_score) { where("enabled_from > ?", mood_score.to_i) }
end
