class InvitationsController < ApplicationController
  def new; end

  def create 
    invitee_email = email_params[:email]
    invitation_token = SecureRandom.alphanumeric(12)

    if User.exists?(invitation_token: invitation_token)
      flash[:alert] = "送信に失敗しました。時間を空けて再度送信を行ってください。"
      redirect_to new_invitation_path
    end

    if current_user.update(invitation_token: invitation_token, invitation_created_at: Time.now)
      InvitationMailer
        .with(inviter: current_user,invitee_email: invitee_email)
        .invite.deliver_later
      flash[:success] = "入力したメールアドレスに招待メールを送信しました。"
      redirect_to new_invitation_path
    else
      flash[:alert] = "招待メールを送信出来ませんでした。"
      redirect_to new_invitation_path
    end
  end

  private

  def email_params
    params.require(:invitation).permit(:email)
  end
end
