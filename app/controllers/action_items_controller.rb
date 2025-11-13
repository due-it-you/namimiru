class ActionItemsController < ApplicationController
  def index
    latest_mood_score = current_user.daily_records.order(created_at: :desc).first&.mood_score
    # スライダーを変動させた後の値 || 初回アクセス時の初期値 || 記録がまだ存在しない場合の初期値
    @mood_score =  params[:mood_score] || latest_mood_score || 0
    # 項目と紐付いている全てのタグ
    @present_tags = current_user.action_items.includes(:action_tag).map(&:action_tag).uniq

    selected_tag_name = params[:selected_tag_name]
    groups = current_user.get_action_item_lists_by(@mood_score, selected_tag_name)
    # できるかもリストの項目
    @diff_can_groups, @not_diff_can_groups = groups[:diff_can_groups], groups[:not_diff_can_groups]
    # できないかもリストの項目
    @diff_cannot_groups, @not_diff_cannot_groups = groups[:diff_cannot_groups], groups[:not_diff_cannot_groups]
    # やらない方がいいリストの項目
    @avoid_groups = groups[:avoid_groups]

    respond_to do |f|
      f.html
      f.turbo_stream
    end
  end

  def new
    @action_item = current_user.action_items.new
  end

  def create
    # 既存のタグにない名称が入力された場合 || 既存のタグが選択された場合 || 未入力の場合
    tag_name = action_item_params[:tag_name].presence ||
               current_user.action_tags.find_by(id: action_item_params[:action_tag_id])&.name ||
               "未分類"
    action_tag = current_user.action_tags.find_or_initialize_by(name: tag_name)

    @action_item = current_user.action_items.new(
      name: action_item_params[:name],
      enabled_from: action_item_params[:enabled_from],
      behavior_type: action_item_params[:behavior_type]
    )
    # ActionItemモデルのvalidates_associated :action_tagによってaction_item.saveで
    # 関連付けられたaction_tagにもバリデーションが走る
    @action_item.action_tag = action_tag
    if @action_item.save
      flash[:success] = "項目を作成しました。"
      redirect_to action_items_path(format: :html)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @action_item = current_user.action_items.find(params[:id])
  end

  def update
    @action_item = current_user.action_items.find(params[:id])
    action_tag = current_user.action_tags.find_or_create_by(
      # 既存のタグにない名称が入力された場合 || 既存のタグが選択された場合 || 未入力の場合
      name: action_item_params[:tag_name].presence || current_user.action_tags.find_by(id: action_item_params[:action_tag_id])&.name || "未分類"
    )
    @action_item.action_tag = action_tag
    if @action_item.update(
      name: action_item_params[:name],
      enabled_from: action_item_params[:enabled_from],
      action_tag_id: action_tag.id,
      behavior_type: action_item_params[:behavior_type]
    )
      flash[:success] = "行動項目を更新しました。"
      redirect_to action_items_path(format: :html)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    action_item = current_user.action_items.find(params[:id])
    if action_item.destroy
      flash[:success] = "行動項目を削除しました。"
      redirect_to action_items_path(format: :html)
    else
      flash[:success] = "行動項目を削除できませんでした。"
      redirect_to action_items_path(format: :html)
    end
  end

  private

  def action_item_params
    params.require(:action_item).permit(:name, :action_tag_id, :enabled_from, :tag_name, :behavior_type)
  end
end
