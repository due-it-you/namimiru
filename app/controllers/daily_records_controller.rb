class DailyRecordsController < ApplicationController
  def index
    @daily_record = DailyRecord.new
  end
end
