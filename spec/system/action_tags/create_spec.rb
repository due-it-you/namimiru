require 'rails_helper'

RSpec.describe "CreateActionTags", type: :system do
  describe "行動タグの作成機能" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit new_action_item_path
      fill_in "action_item[name]", with: "自炊"
    end

    context "タグの新規作成が成功した場合" do
      before do
        # comboboxを開く
        find('input[role="combobox"]#action_item_action_tag_id').click
        # タグを入力 
        find('input[role="combobox"]:visible').fill_in(with: '食事')
      end
      
      it "/action_items.htmlにリダイレクトされること" do
        click_on "commit"  
        expect(page).to have_current_path(action_items_path(format: :html))
      end

      it "作成したタグが画面に表示されていること" do
        click_on "commit"
        expect(page).to have_content '食事'
      end

      it "項目作成画面の入力候補として表示されていること" do
        click_on "commit"
        find("#action-item-new-button").click
        # comboboxを開く
        find('input[role="combobox"]#action_item_action_tag_id').click
        expect(page).to have_content '食事'
      end
    end
  end
end

