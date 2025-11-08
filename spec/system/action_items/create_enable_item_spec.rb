require 'rails_helper'

RSpec.describe "CreateEnableItem", type: :system do
  describe "できるかも/できないかもリスト内の項目の作成機能" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit new_action_item_path
    end

    # 正常系
    context "作成が成功した場合" do
      before do
        fill_in "action_item[name]", with: "自炊"
      end

      it "/action_items.htmlにリダイレクトされていること" do
        click_on "commit"
        expect(page).to have_current_path(action_items_path(format: :html))
      end

      it "作成した項目名が画面に表示されていること" do
        click_on "commit"
        expect(page).to have_content "自炊"
      end

      it "成功のフラッシュカードが表示されていること" do
        click_on "commit"
        expect(page).to have_content "項目を作成しました。"
      end
    end
  end
end
