class DailyRecordsController < ApplicationController
  def index
    @daily_record = DailyRecord.new
  before_action :authenticate_user!
  end
end
