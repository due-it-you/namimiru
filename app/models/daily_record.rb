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

  def self.get_chart_data_by(user, range)
    # グラフ表示のためのラベルとデータ
    score_by_date = {}
    # { 記録が存在する日付: [気分の数値, ざわざわしているか], ... }
    score_and_time_pairs = user.daily_records.pluck(:mood_score, :is_uneasy, :created_at)
    score_and_time_pairs.each do |score, is_uneasy, created_at|
      date = created_at.to_date
      score_by_date[date] = [ score, is_uneasy ]
    end

    # 1ヶ月分の記録の配列で、記録が存在していればその記録のデータ、なければnil
    range = selected_range_object(range, user) || (1.months.ago.to_date..Date.current)
    labels = range.to_a
    data = range.map { |date| score_by_date[date]&.first }
    uneasy_flags = range.map { |date| score_by_date[date]&.last }

    chart_data = {
      labels: labels,
      data: data,
      uneasy_flags: uneasy_flags
    }
    chart_data
  end

  private

  def self.selected_range_object(selected_range, user)
    case selected_range
    when "last_week"
      (1.week.ago.to_date..Date.current)
    when "last_month"
      (1.month.ago.to_date..Date.current)
    when "last_3_months"
      (3.months.ago.to_date..Date.current)
    when "last_6_months"
      (6.months.ago.to_date..Date.current)
    when "last_year"
      (1.year.ago.to_date..Date.current)
    when "all_time"
      (user.daily_records.order(created_at: :ASC).first.created_at.to_date..Date.current)
    end
  end
end
