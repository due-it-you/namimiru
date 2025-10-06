class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def top; end
  
  def terms_of_service; end
end
