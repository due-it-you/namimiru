class ChartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @daily_records = current_user.daily_records
      .where(created_at: 1.months.ago.beginning_of_day..Time.current.end_of_day)
      .order(created_at: :ASC)
  end
end
