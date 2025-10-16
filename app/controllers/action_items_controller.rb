class ActionItemsController < ApplicationController
  def index
    latest_mood_score = current_user.daily_records.order(created_at: :desc).first&.mood_score
    # スライダーを変動させた後の値 || 初回アクセス時の初期値 || 記録がまだ存在しない場合の初期値
    @mood_score =  params[:mood_score] || latest_mood_score || 0
    current_can_items, current_cannot_items = current_user.action_items.capable(@mood_score),  current_user.action_items.incapable(@mood_score)
    latest_can_items, latest_cannot_items = current_user.action_items.capable(latest_mood_score), current_user.action_items.incapable(latest_mood_score)

    # 最新の記録の気分のリストと比べての項目の差分
    @diff_can_items = current_can_items - latest_can_items
    @not_diff_can_items = current_can_items - @diff_can_items

    @diff_cannot_items = current_cannot_items - latest_cannot_items
    @not_diff_cannot_items = current_cannot_items - @diff_cannot_items

    if turbo_frame_request?
      render partial: "action_items/lists_frame"
    end
  end

  def new
    @action_item = ActionItem.new
  end

  def create
    action_tag = current_user.action_tags.find_or_create_by(name: action_item_params[:tag_name])
    action_item = current_user.action_items.new(
      user_id: current_user.id,
      action_tag_id: action_tag.id,
      name: action_item_params[:name],
      enabled_from: action_item_params[:enabled_from]
    )
    if action_item.save
      flash[:success] = "項目を作成しました。"
      redirect_to action_items_path
    else
      flash[:alert] = "項目の作成が出来ませんでした。"
      redirect_to action_items_path
    end
  end

  def edit
    @action_item = current_user.action_items.find(params[:id])
  end

  def update
    action_item = current_user.action_items.find(params[:id])
    if action_item.update(action_item_params)
      flash[:success] = "行動項目を更新しました。"
      redirect_to action_items_path
    else
      flash[:alert] = "行動項目を更新出来ませんでした。"
      redirect_to action_items_path
    end
  end

  def destroy
    action_item = current_user.action_items.find(params[:id])
    if action_item.destroy
      flash[:success] = "行動項目を削除しました。"
      redirect_to action_items_path
    else
      flash[:success] = "行動項目を削除できませんでした。"
      redirect_to action_items_path
    end
  end

  private

  def action_item_params
    params.require(:action_item).permit(:name, :enabled_from, :tag_name)
  end
end
