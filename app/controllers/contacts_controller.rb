class ContactsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @contact = Contact.new
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      ContactMailer.send_mail(contact).deliver_later
      flash[:success] = "お問い合わせ内容を送信しました。"
      redirect_to new_contact_path
    else
      flash[:alert] = "お問い合わせ内容を送信できませんでした。"
      redirect_to new_contact_path
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
