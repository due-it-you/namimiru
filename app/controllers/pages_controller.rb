class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def top; end

  def terms_of_service; end

  def privacy_policy; end

  def befind_the_scene; end
end
