class InvitationsController < ApplicationController
  def new; end

  def create
    invitee_email = invitation_params[:email]
    invitee_role = invitation_params[:invitee_role]
    invitation_token = current_user.generate_unique_invitation_token

    current_user.assign_attributes(invitation_token: invitation_token, invitation_created_at: Time.now, invitee_role: invitee_role)
    if current_user.save(context: :invitation)
      InvitationMailer.with(inviter: current_user, invitee_email: invitee_email).invite.deliver_later
      flash[:success] = "入力したメールアドレスに招待メールを送信しました。"
      redirect_to new_invitation_path
    else
      flash[:alert] = "招待メールを送信出来ませんでした。"
      redirect_to new_invitation_path
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email, :invitee_role)
  end
end
