class DailyRecord < ApplicationRecord
  belongs_to :user

  validates :mood_score, presence: true, numericality: { in: -5..5 }
  validates :memo, length: { maximum: 500 }
  # boolean型におけるバリデーション
  validates :is_uneasy, inclusion: { in: [ true, false ] }

  scope :with_selected_range, ->(selected_range) {
    range =
      case selected_range
      when "last_week" then 1.week.ago.beginning_of_day..Time.current.end_of_day
      when "last_month" then 1.month.ago.beginning_of_day..Time.current.end_of_day
      when "last_3_months" then 3.months.ago.beginning_of_day..Time.current.end_of_day
      when "last_6_months" then 6.months.ago.beginning_of_day..Time.current.end_of_day
      when "last_year" then 1.year.ago.beginning_of_day..Time.current.end_of_day
      end
    selected_range == "all_time" ? order(created_at: :ASC) : where(created_at: range).order(created_at: :ASC)
  }
end
