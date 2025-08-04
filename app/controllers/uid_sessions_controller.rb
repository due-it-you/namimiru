class UidSessionsController < ApplicationController
  def create
  end

  private

  def idtoken_params
    params.require(:uid_session).permit(:id_token)
  end
end
