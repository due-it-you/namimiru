class LogsController < ApplicationController
  def new
  end

  private

  def user_params
    params.require(:user).permit(:id_token, :role)
  end
end
