class ChartsController < ApplicationController
  before_action :authorize_the_chart!, only: %i[show data]

  def index
    @current_user = current_user
  end

  def show
    @user = User.find(params[:user_id])
    @latest_record = @user.daily_records.order(created_at: :ASC).last

    # グラフ表示のためのラベルとデータ
    score_by_date = {}
    score_and_time_pairs = @user.daily_records.pluck(:mood_score, :created_at)
    score_and_time_pairs.each do |score, created_at|
      date = created_at.to_date
      score_by_date[date] = score
    end

    one_month = (1.months.ago.to_date..Date.current)
    @labels = one_month.to_a
    @data = one_month.map { |date| score_by_date[date] }
  end

  def data
    user = User.find(params[:user_id])
    # グラフ表示のためのラベルとデータ
    range = selected_range_object(params[:range], user)
    score_by_date = {}
    score_and_time_pairs = user.daily_records.pluck(:mood_score, :created_at)
    score_and_time_pairs.each do |score, created_at|
      date = created_at.to_date
      score_by_date[date] = score
    end

    labels = range.to_a
    data = range.map { |date| score_by_date[date] }
    chart_data = { labels: labels, data: data }
    render json: chart_data
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
