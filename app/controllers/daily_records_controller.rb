class DailyRecordsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  private

  def daily_record_params
    params.require(:daily_record).permit(:mood_score, :memo)
  end
end
