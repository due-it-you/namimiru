class ChartsController < ApplicationController
  before_action :authorize_the_chart!, only: %i[index]

  def index
    @user = User.find_by(id: params[:user_id]) || current_user
    @latest_record = @user.daily_records.order(created_at: :ASC).last

    chart_data = DailyRecord.get_chart_data_by(@user, params[:range])
    @labels = chart_data[:labels]
    @data = chart_data[:data]
    @uneasy_flags = chart_data[:uneasy_flags]
    respond_to do |f|
      f.html
      f.json { render json: chart_data }
      f.turbo_stream
    end
  end

  private

  def authorize_the_chart!
    user = params[:user_id].present? ? User.find(params[:user_id]) : current_user
    # 自身のグラフを確認する時は常にアクセスを許可
    return if current_user == user
    # アクセスを試みているユーザーと連携状態にない場合にリダイレクト
    if !CareRelation.exists?(supported_id: user.id, supporter_id: current_user.id) && !CareRelation.exists?(supported_id: current_user.id, supporter_id: user.id)
      flash[:alert] = "このグラフのユーザーと連携状態にありません。"
      redirect_to charts_path
    end
  end
end
