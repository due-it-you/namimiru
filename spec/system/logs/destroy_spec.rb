RSpec.describe "Update", type: :system do
  describe "記録削除機能" do
    let(:user) { create(:user) }
    let(:daily_record) { create(:daily_record, user: user) }

    before do
      sign_in user 
      visit user_daily_record_path(user.id, daily_record.id)
      click_on "編集"
    end

    context "記録の削除に成功した場合" do
      it "記録が記録一覧画面から消えていること" do
        accept_confirm do
          click_link "trash-icon" 
        end
        expect(page).to have_current_path user_daily_records_path(user.id)
        expect(page).to have_content "記録の削除が完了しました。"
        expect(page).not_to have_content "（#{daily_record.mood_score}）"
        expect(page).not_to have_content daily_record.memo
      end
    end
  end
end
