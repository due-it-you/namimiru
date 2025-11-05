require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe 'inviteメソッドで送るメールの検証' do
    let!(:user) { create(:user) }
    let!(:invitee_email) { "test@example.com" }
    let!(:mail) { InvitationMailer.with(inviter: user, invitee_email: invitee_email).invite }

    before do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.deliveries.clear
    end

    it "メール本文に招待コードが含まれていること" do
      user.update(invitation_token: SecureRandom.alphanumeric(12))
      mail.deliver_now
      last_mail = ActionMailer::Base.deliveries.last
      expect(last_mail.body).to match(user.invitation_token)
    end

    it "メールを実際に送信できていること" do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end
end
