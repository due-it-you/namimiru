class ActionItem < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :enabled_from, presence: true, numericality: { in: -5..5 }

  # できるリストに表示される行動項目の検索
  scope :capable, ->(mood_score) { where("enabled_from <= ?", mood_score.to_i) }
  # できないリストに表示される行動項目の検索
  scope :incapable, ->(mood_score) { where("enabled_from > ?", mood_score.to_i) }
end
