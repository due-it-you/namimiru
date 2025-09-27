class CareRelationsController < ApplicationController
  INVITATION_EXPIRATION_MINUTES = 15.minutes.freeze

  def index; end

  def new; end

  def create
    invitation_token = invitation_token_params[:invitation_token]
    inviter = User.find_by(invitation_token: invitation_token)
    invitee = current_user

    # 招待コードが存在していないか有効期限を超えている場合
    if inviter.nil? || inviter.invitation_created_at <= INVITATION_EXPIRATION_MINUTES.ago
      flash[:alert] = "招待コードが存在していないか、有効期限を超えています。"
      redirect_to new_care_relation_path and return
    end

    # 招待されたユーザーの役割に応じて「支援者」「双極性障害の方」のいずれかに振り分け
    if inviter.invitee_role == "supported"
      supported_id = invitee.id
      supporter_id = inviter.id
    else
      supported_id = inviter.id
      supporter_id = invitee.id
    end

    if CareRelation.where(supported_id: supported_id, supporter_id: supporter_id).exists?
      flash[:alert] = "すでに連携済みです。"
      redirect_to new_care_relation_path and return
    end

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
