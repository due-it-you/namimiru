class ChartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_user = current_user
  end

  def show
    user = User.find(params[:user_id])
    @latest_record = user.daily_records.order(created_at: :ASC).last

    # グラフ表示のためのラベルとデータ
    daily_records = user.daily_records
      .where(created_at: 1.months.ago.beginning_of_day..Time.current.end_of_day)
      .order(created_at: :ASC)
    @labels = daily_records.map { |record| record.created_at.strftime("%m/%d").to_json }
    @data = daily_records.map { |record| record.mood_score }
  end
end
