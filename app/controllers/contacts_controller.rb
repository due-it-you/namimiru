class ContactsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @contact = Contact.new
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :subject, :message)
  end
end
