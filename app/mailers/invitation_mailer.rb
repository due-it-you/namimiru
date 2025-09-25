class InvitationMailer < ApplicationMailer
  default from: "namimiruOfficial@gmail.com"

  def invite
    @inviter = params[:user]
    invitee_email = params[:email]
    mail(to: invitee_email, subject: "招待コードを入力して連携しましょう！ ナミミルからのお知らせ")
  end
end
