require 'rails_helper'
require 'securerandom'

RSpec.describe "CreateEnableItem", type: :system do
  describe "できるかも/できないかもリスト内の項目の作成機能" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit new_action_item_path
    end

    # 正常系
    context "作成が成功した場合" do
      let(:valid_action_item_name) { SecureRandom.alphanumeric(15) }

      before do
        fill_in "action_item[name]", with: valid_action_item_name
      end

      it "/action_items.htmlにリダイレクトされていること" do
        click_on "commit"
        expect(page).to have_current_path(action_items_path(format: :html))
      end

      it "作成した項目名が画面に表示されていること" do
        click_on "commit"
        expect(page).to have_content valid_action_item_name
      end

      it "成功のフラッシュカードが表示されていること" do
        click_on "commit"
        expect(page).to have_content "項目を作成しました。"
      end
    end

    # 異常系
    context "作成が失敗した場合" do
      context "項目名が上限の15文字を超えている場合" do
        let(:invalid_action_item_name) { SecureRandom.alphanumeric(16) }
        before do
          fill_in "action_item[name]", with: invalid_action_item_name
        end

        it "画面に作成しようとした項目名が表示されていないこと" do
          click_on "commit"
          expect(page).not_to have_content invalid_action_item_name
        end

        it "失敗のフラッシュメッセージが表示されていること" do
          click_on "commit"
          expect(page).to have_content "項目名は15文字以内で入力してください。"
        end
      end
    end
  end
end
