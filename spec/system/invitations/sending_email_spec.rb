include ActiveJob::TestHelper

RSpec.describe "InvitationsSendingEmail", type: :system do
  describe "招待メールの送信機能" do
    let!(:user) { create(:user) }

    before do
      sign_in user
      visit new_invitation_path
    end

    context "メールの送信が完了した場合" do
      it "完了のフラッシュメッセージが表示されていること" do
        select "双極性障害を持つ方", from: "invitation[invitee_role]"
        fill_in "invitation[email]", with: "test@example.com"
        click_on "招待メールを送信"
        expect(page).to have_content "入力したメールアドレスに招待メールを送信しました。"
      end
    end
  end
end
