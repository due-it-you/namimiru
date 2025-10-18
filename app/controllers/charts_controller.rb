class ChartsController < ApplicationController
  before_action :authorize_the_chart!, only: %i[show data]

  def index
    @current_user = current_user
  end

  def show
    @user = User.find(params[:user_id])
    @latest_record = @user.daily_records.order(created_at: :ASC).last

    # グラフ表示のためのラベルとデータ
    one_month = (1.months.ago.to_date..Date.current)
    @labels = one_month.to_a
    @data = one_month.map do |date| 
      record = @user.daily_records.find_by(created_at: date.all_day)
      record&.mood_score
    end
  end

  def data
    user = User.find(params[:user_id])
    daily_records = user.daily_records.with_selected_range(params[:range])
    labels = daily_records.map { |record| record.created_at.strftime("%m/%d").to_json }
    data = daily_records.map { |record| record.mood_score }
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
end
