class CareRelationsController < ApplicationController
  def index; end

  def new; end

  def create
    inviter = User.find_by(invitation_token: invitation_token_params[:invitation_token])
    invitee = current_user
    # 招待されたユーザーの役割に応じて「支援者」「双極性障害の方」のいずれかに振り分け
    supported_id, supporter_id = User.assign_care_relation_ids(inviter: inviter, invitee: invitee)

    return redirect_to(new_care_relation_path, alert: "招待コードが存在していないか、有効期限を超えています。") if inviter.nil? || inviter.invitation_token_expired?
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

  private

  def invitation_token_params
    params.require(:user).permit(:invitation_token)
  end
end
