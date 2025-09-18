class DailyRecord < ApplicationRecord
  belongs_to :user

  validates :mood_score, presence: true, numericality: { in: -5..5 }
  validates :memo, length: { maximum: 500 }
end
