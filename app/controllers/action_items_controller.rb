class ActionItemsController < ApplicationController
  def index; end

  def new
    @action_item = ActionItem.new
  end

  private

  def action_item_params
    params.require(:action_item).permit(:name, :enabled_from)
  end
end
