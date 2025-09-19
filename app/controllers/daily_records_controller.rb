class DailyRecordsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create 
    daily_record = current_user.daily_records.new(daily_record_params)
    if daily_record.save
      flash[:success] = "記録の作成が完了しました。"
      redirect_to charts_path
    else
      flash[:danger] = "記録の作成に失敗しました。"
      render :new
    end
  end

  private

  def daily_record_params
    params.require(:daily_record).permit(:mood_score, :memo)
  end
end
