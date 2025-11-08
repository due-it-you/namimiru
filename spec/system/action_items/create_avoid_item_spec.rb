require 'rails_helper'

RSpec.describe "CreateAvoidItem", type: :system do
  describe "躁の時にやらない方がいい行動リスト内の項目の作成機能" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit new_action_item_path
      select "躁状態の時にやらない方がいい行動", from: "action_item[behavior_type]"
    end

    # 正常系
    context "作成に成功した場合" do
      let(:valid_action_item_name) { SecureRandom.alphanumeric(15) }

      before do
        fill_in "action_item[name]", with: valid_action_item_name
      end
        
      it "/action_items.htmlにリダイレクトされていること" do
        click_on "commit"
        expect(page).to have_current_path(action_items_path(format: :html))
      end

      it "成功のフラッシュメッセージが表示されること" do
        click_on "commit"
        expect(page).to have_content "項目を作成しました。"
      end

      it "作成した項目名が表示されていること" do
        click_on "commit"
        find('#mood-range').set(1)
        expect(page).to have_content valid_action_item_name
      end
    end

    # 異常系
    context "作成に失敗した場合" do
      context "項目名が上限の15文字を超えていた場合" do
        let(:invalid_action_item_name) { SecureRandom.alphanumeric(16) }

        before do
          fill_in "action_item[name]", with: invalid_action_item_name
        end
        
        it "/action_items/newの画面が表示されていること" do
          click_on "commit"
          expect(page).to have_current_path(new_action_item_path)
        end

        it "項目名に関するエラーメッセージが表示されていること" do
          click_on "commit"
          expect(page).to have_content "項目名は15文字以内で入力してください。"
        end
      end
    end
  end
end
