class CareRelationsController < ApplicationController
  before_action :authorize_care_relation!, only: %i[show destroy]

  def index
    @care_relations_supporting = current_user.supporting_relationships.includes(:supported)
    @care_relations_supporter = current_user.being_supported_relationships.includes(:supporter)
  end

  def new; end

  def create
    inviter = User.find_by(invitation_token: invitation_token_params[:invitation_token])
    invitee = current_user

    return redirect_to(new_care_relation_path, alert: "同一ユーザーで連携は出来ません。") if inviter == invitee
    return redirect_to(new_care_relation_path, alert: "招待コードが存在していないか、有効期限を超えています。") if inviter.nil? || inviter.invitation_token_expired?

    # 招待されたユーザーの役割に応じて「支援者」「双極性障害の方」のいずれかに振り分け
    supported_id, supporter_id = User.assign_care_relation_ids(inviter: inviter, invitee: invitee)

    return redirect_to(new_care_relation_path, alert: "すでに連携済みです。") if CareRelation.where(supported_id: supported_id, supporter_id: supporter_id).exists?

    @care_relation = CareRelation.new(supported_id: supported_id, supporter_id: supporter_id)
    if @care_relation.save
      flash[:success] = "招待したユーザーと連携状態になりました！"
      redirect_to care_relations_path
    else
      flash[:alert] = "連携できませんでした。"
      redirect_to new_care_relation_path
    end
  end

  def show
    @care_relation = CareRelation.find(params[:id])
    @user = @care_relation.supported == current_user ? @care_relation.supporter : @care_relation.supported
  end

  def destroy
    care_relation = CareRelation.find(params[:id])
    if care_relation.destroy
      flash[:success] = "連携の解除に成功しました！"
      redirect_to care_relations_path, status: :see_other
    else
      flash[:alert] = "連携の解除に失敗しました。"
      redirect_to care_relations_path
    end
  end

  private

  def invitation_token_params
    params.require(:user).permit(:invitation_token)
  end

  def authorize_care_relation!
    @care_relation = CareRelation.find(params[:id])
    # アクセスしようとしている連携情報に、
    # 現在ログイン中のユーザーの情報がなければ権限なしとしてリダイレクト
    if current_user.absent_from_the_care_relation?(@care_relation)
      flash[:alert] = "アクセスしようとしているページの権限がありません。"
      redirect_to care_relations_path
    end
  end
end
