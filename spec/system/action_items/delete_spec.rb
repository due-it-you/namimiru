require 'rails_helper'

RSpec.describe "DeleteActionItem", type: :system do
  describe "行動項目の削除" do
    let!(:user) { create(:user) }
    let!(:action_tag) { create(:action_tag, user: user) }
    let!(:action_item) { create(:action_item, user: user, action_tag: action_tag) }


    before do
      sign_in user
      visit action_items_path(format: :html)
    end

    context "削除に成功した場合" do
      before do
        # 項目UIをクリック
        click_on action_item.name 
      end

      it "/action_items.htmlにリダイレクトしていること" do
        accept_confirm do
          click_link "trash-icon"
        end
        expect(page).to have_current_path(action_items_path(format: :html))
      end

      it "成功のフラッシュメッセージが表示されていること" do
        accept_confirm do
          click_link "trash-icon"
        end
        expect(page).to have_content "行動項目を削除しました。"
      end

      it "リスト内から消えていること" do
        accept_confirm do
          click_link "trash-icon"
        end
        within("#can-list") do
          expect(page).not_to have_content action_item.name
        end

        within("#cannot-list") do
          expect(page).not_to have_content action_item.name
        end

        find("#switch-unenable-and-avoid-lists-icon").click
        within("#avoid-list") do
          expect(page).not_to have_content action_item.name
        end
      end
    end
  end
end

