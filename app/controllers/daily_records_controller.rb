class DailyRecordsController < ApplicationController
  before_action :authenticate_user!

  ONE_WEEK_DAYS = 7.freeze

  def index
    @user = User.find(params[:user_id])
    @daily_records = @user.daily_records.order(created_at: :DESC).page(params[:page]).per(ONE_WEEK_DAYS)
  end

  def show
    @daily_record = DailyRecord.find(params[:id])
  end

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

  def edit
    @daily_record = DailyRecord.find(params[:id])
  end

  def update
    daily_record = DailyRecord.find(params[:id])
    if daily_record.update(daily_record_params)
      flash[:success] = "記録の更新に成功しました。"
      redirect_to user_daily_record_path(daily_record.user.id, daily_record.id), status: :see_other
    else
      flash[:alert] = "記録の更新に失敗しました。"
      redirect_to user_daily_record_path(daily_record.user.id, daily_record.id)
    end
  end

  def destroy
    daily_record = DailyRecord.find(params[:id])
    if daily_record.destroy
      flash[:success] = "記録の削除が完了しました。"
      redirect_to user_daily_records_path(daily_record.user.id), status: :see_other
    else
      flash[:alert] = "記録の削除に失敗しました。"
      redirect_to user_daily_record_path(daily_record.user.id, daily_record.id)
    end
  end

  private

  def daily_record_params
    params.require(:daily_record).permit(:mood_score, :memo)
  end
end
