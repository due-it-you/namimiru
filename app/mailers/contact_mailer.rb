class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail(to: ENV["SENDER_EMAIL"], subject: "【問い合わせ】" + @contact.subject)
  end
end
