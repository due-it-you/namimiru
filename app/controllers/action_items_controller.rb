class ActionItemsController < ApplicationController
  def index
    latest_mood_score = current_user.daily_records.order(created_at: :desc).first&.mood_score
    # スライダーを変動させた後の値 || 初回アクセス時の初期値 || 記録がまだ存在しない場合の初期値
    @mood_score =  params[:mood_score] || latest_mood_score || 0

    action_items_with_tag = current_user.action_items.includes(:action_tag)
    # 現在リストの中に存在する全てのタグの名前
    @present_tags = action_items_with_tag.map(&:action_tag).uniq
    selected_tag_name = params[:selected_tag_name]
    if selected_tag_name.present?
      selected_tag = current_user.action_tags.find_by(name: selected_tag_name)
      current_can_items, current_cannot_items = selected_tag.action_items.capable(@mood_score),  selected_tag.action_items.incapable(@mood_score)
      latest_can_items, latest_cannot_items = selected_tag.action_items.capable(latest_mood_score), selected_tag.action_items.incapable(latest_mood_score)
    else
      current_can_items, current_cannot_items = action_items_with_tag.capable(@mood_score),  action_items_with_tag.incapable(@mood_score)
      latest_can_items, latest_cannot_items = action_items_with_tag.capable(latest_mood_score), action_items_with_tag.incapable(latest_mood_score)
    end

    # 最新の記録の気分のリストと比べての項目の差分
    diff_can_items = current_can_items - latest_can_items
    not_diff_can_items = current_can_items - diff_can_items
    diff_cannot_items = current_cannot_items - latest_cannot_items
    not_diff_cannot_items = current_cannot_items - diff_cannot_items

    # 項目をタグごとにまとめる
    @diff_can_groups, @not_diff_can_groups = diff_can_items.group_by(&:action_tag), not_diff_can_items.group_by(&:action_tag)
    @diff_cannot_groups, @not_diff_cannot_groups = diff_cannot_items.group_by(&:action_tag), not_diff_cannot_items.group_by(&:action_tag)

    if turbo_frame_request?
      render partial: "action_items/lists_frame"
    end
  end

  def new
    @action_item = ActionItem.new
  end

  def create
    action_tag = current_user.action_tags.find_or_create_by(
      # 既存のタグにない名称が入力された場合 || 既存のタグが選択された場合 || 未入力の場合
      name:  action_item_params[:tag_name].presence || current_user.action_tags.find_by(id: action_item_params[:action_tag_id])&.name || "未分類"
    )
    action_item = current_user.action_items.new(
      user_id: current_user.id,
      action_tag_id: action_tag.id,
      name: action_item_params[:name],
      enabled_from: action_item_params[:enabled_from],
      behavior_type: action_item_params[:behavior_type].to_i
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
    action_tag = current_user.action_tags.find_or_create_by(
      # 既存のタグにない名称が入力された場合 || 既存のタグが選択された場合 || 未入力の場合
      name: action_item_params[:tag_name].presence || current_user.action_tags.find_by(id: action_item_params[:action_tag_id])&.name || "未分類"
    )
    if action_item.update(
      name: action_item_params[:name],
      enabled_from: action_item_params[:enabled_from],
      action_tag_id: action_tag.id
    )
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
    params.require(:action_item).permit(:name, :action_tag_id, :enabled_from, :tag_name, :behavior_type)
  end
end
