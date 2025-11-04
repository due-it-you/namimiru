class ChartsController < ApplicationController
  before_action :authorize_the_chart!, only: %i[show data]

  def index
    @user = User.find_by(id: params[:user_id]) || current_user 
    @latest_record = @user.daily_records.order(created_at: :ASC).last

    # グラフ表示のためのラベルとデータ
    score_by_date = {}
    # { 記録が存在する日付: [気分の数値, ざわざわしているか], ... }
    score_and_time_pairs = @user.daily_records.pluck(:mood_score, :is_uneasy, :created_at)
    score_and_time_pairs.each do |score, is_uneasy, created_at|
      date = created_at.to_date
      score_by_date[date] = [ score, is_uneasy ]
    end

    # 1ヶ月分の記録の配列で、記録が存在していればその記録のデータ、なければnil
    range = selected_range_object(params[:range], @user) || (1.months.ago.to_date..Date.current)
    @labels = range.to_a
    @data = range.map { |date| score_by_date[date]&.first }
    @uneasy_flags = range.map { |date| score_by_date[date]&.last }
    chart_data = { labels: @labels, data: @data, uneasy_flags: @uneasy_flags }
    respond_to do |f|
      f.html
      f.json { render json: chart_data }
    end
  end

  private

  def authorize_the_chart!
    user = User.find(params[:user_id])
    # 自身のグラフを確認する時は常にアクセスを許可
    return if current_user == user
    # アクセスを試みているユーザーと連携状態にない場合にリダイレクト
    if !CareRelation.exists?(supported_id: user.id, supporter_id: current_user.id) && !CareRelation.exists?(supported_id: current_user.id, supporter_id: user.id)
      flash[:alert] = "このグラフのユーザーと連携状態にありません。"
      redirect_to charts_path
    end
  end

  def selected_range_object(selected_range, user)
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
