class CareRelationsController < ApplicationController
  def index; end

  def new; end

  def create; end

  private

  def invitation_token_params
    params.require(:user).permit(:invitation_token)
  end
end
