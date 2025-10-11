class ActionItemsController < ApplicationController
  def index; end

  def new
    @action_item = ActionItem.new
  end
end
