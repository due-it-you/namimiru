class ActionItem < ApplicationRecord
  belongs_to :user
  belongs_to :action_tag

  validates :name, presence: true
  validates :enabled_from, numericality: { in: -5..5 }, allow_nil: true

  enum :behavior_type, {
    dynamic: 0, # できるかも/できないかもリスト内の項目
    avoid: 1  # やらない方がいいリスト内の項目
  }, validate: true

  # できるリストに表示される行動項目の検索
  scope :capable, ->(mood_score) { where("enabled_from <= ?", mood_score.to_i) }
  # できないリストに表示される行動項目の検索
  scope :incapable, ->(mood_score) { where("enabled_from > ?", mood_score.to_i) }
end
