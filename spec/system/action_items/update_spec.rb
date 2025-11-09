require 'rails_helper'

RSpec.describe "UpdateActionItemAndTag", type: :system do
  describe "項目・タグの更新機能" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit new_action_item_path
    end

    describe "項目名・タグ名・気分の数値の更新" do

      context "更新が成功した場合" do
        before do
          fill_in "action_item[name]", with: "自炊"
          click_on "commit"
          # 作成された項目UIをクリックして編集画面に遷移
          click_on "自炊" 
          fill_in "action_item[name]", with: "更新後の項目名"
          # comboboxを開く
          find('input[role="combobox"]#action_item_action_tag_id').click
          # 新しいタグを入力
          find('input[role="combobox"]:visible').fill_in(with: '更新後のタグ名')
        end

        it "/action_items.htmlにリダイレクトされていること" do
          click_on "commit"
          expect(page).to have_current_path(action_items_path(format: :html))
        end

        it "フラッシュメッセージが表示されていること" do
          click_on "commit"
          expect(page).to have_content "行動項目を更新しました。"
        end

        it "更新後の内容が画面に表示されていること" do
          click_on "commit"
          expect(page).to have_content "更新後の項目名"
          expect(page).to have_content "更新後のタグ名"
        end
      end
    end
  end
end
