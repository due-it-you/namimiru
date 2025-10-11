class ActionItemsController < ApplicationController
  def index; end

  def new
    @action_item = ActionItem.new
  end

  def create 
    action_item = current_user.action_items.new(action_item_params)
    if action_item.save
      flash[:success] = "項目を作成しました。"
      redirect_to action_items_path
    else
      flash[:alert] = "項目の作成が出来ませんでした。"
      redirect_to action_items_path
    end
  end

  private

  def action_item_params
    params.require(:action_item).permit(:name, :enabled_from)
  end
end
