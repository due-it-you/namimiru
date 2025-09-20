class ChartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @latest_record = current_user.daily_records.last

    # グラフ表示のためのラベルとデータ
    daily_records = current_user.daily_records
      .where(created_at: 1.months.ago.beginning_of_day..Time.current.end_of_day)
      .order(created_at: :ASC)
    @labels = daily_records.map { |record| record.created_at.strftime("%m/%d").to_json }
    @data = daily_records.map { |record| record.mood_score }
  end
end
