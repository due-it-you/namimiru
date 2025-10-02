require 'rails_helper'

RSpec.describe "Update", type: :system do
  describe '記録更新機能' do
    let(:user) { create(:user) }
    let(:daily_record) { create(:daily_record, user: user) }

    before do
      sign_in user 
      visit user_daily_record_path(user.id, daily_record.id)
      click_link "編集"
    end

    context "記録の更新に成功した場合" do
        it '記録更新後の内容が表示されていること' do
          find_by_id('mood-range').set -2
          fill_in "daily_record[memo]", with: "メモを変更しました。"
          click_on '更新'
          # expect(current_path).to eq user_daily_record_path(user.id, daily_record.id)
          expect(page).to have_content '記録の更新に成功しました。'
          expect(page).to have_content 'ややつらい （-2）'
          expect(page).to have_content 'メモを変更しました。'
        end
    end
  end
end
