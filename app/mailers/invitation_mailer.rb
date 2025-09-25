class InvitationMailer < ApplicationMailer
  def invite
    @inviter = params[:inviter]
    invitee_email = params[:invitee_email]
    mail(from: 'namimiruofficial@gmail.com', to: invitee_email, subject: "招待コードを入力して連携しましょう！ ナミミルからのお知らせ")
  end
end
