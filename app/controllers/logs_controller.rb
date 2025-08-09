class LogsController < ApplicationController
  def new
  end

  private

  def log_params
    params.require(:log).permit(:id_token, :mood_score)
  end
end
