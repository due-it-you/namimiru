class ActionItemsController < ApplicationController
  def index
    latest_mood_score = current_user.daily_records.order(created_at: :desc).first&.mood_score
    # スライダーを変動させた後の値 || 初回アクセス時の初期値 || 記録がまだ存在しない場合の初期値
    @mood_score =  params[:mood_score] || latest_mood_score || 0
    @can_list = current_user.action_items.capable(@mood_score)
    @cannot_list = current_user.action_items.incapable(@mood_score)
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
