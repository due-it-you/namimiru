class DailyRecordsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    if current_user.already_recorded_today?
      flash[:alert] = "すでに今日の記録は作成済みです。"
      redirect_to user_chart_path(current_user.id) and return
    end

    daily_record = current_user.daily_records.new(daily_record_params)
    if daily_record.save
      flash[:success] = "記録の作成が完了しました。"
      redirect_to user_chart_path(current_user.id)
    else
      flash[:alert] = "記録の作成に失敗しました。"
      redirect_to new_daily_record_path
    end
  end

  private

  def daily_record_params
    params.require(:daily_record).permit(:mood_score, :memo)
  end
end
