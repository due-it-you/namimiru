class ActionItemsController < ApplicationController
  def index
    latest_mood_score = current_user.daily_records.order(created_at: :desc).first&.mood_score
    @mood_score =  params[:mood_score] || latest_mood_score || 0
    @can_list = []
    @cannot_list = []
    current_user.action_items.each do |action_item|
      if @mood_score.to_i >= action_item.enabled_from.to_i
        @can_list << action_item
      else
        @cannot_list << action_item
      end
    end
    if turbo_frame_request?
      render partial: "action_items/lists_frame"
    end
  end

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
