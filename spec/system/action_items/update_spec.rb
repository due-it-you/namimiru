require 'rails_helper'

RSpec.describe "UpdateActionItemAndTag", type: :system do
  describe "項目・タグの更新機能" do
    let(:user) { create(:user) }
    let!(:action_tag) { create(:action_tag, user: user) }
    let!(:action_item) { create(:action_item, user: user, action_tag: action_tag) }


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

      context "更新が失敗した場合" do
        context "項目名が15文字を超えている場合" do
          let(:invalid_random_action_item_name) { SecureRandom.alphanumeric(16) }

          before do
            visit action_items_path(format: :html)
            # 項目UIをクリックして編集画面に遷移
            click_on action_item.name
            # 不正な項目名を入力
            fill_in "action_item[name]", with: invalid_random_action_item_name
          end

          it "該当の編集画面が表示されていること" do
            click_on "commit"
            expect(page).to have_current_path(edit_action_item_path(action_item.id))
          end

          it "エラーメッセージが表示されていること" do
            click_on "commit"
            expect(page).to have_content "項目名は15文字以内で入力してください。"
          end
        end

        context "タグ名が8文字を超えている場合" do
          let(:invalid_random_action_tag_name) { SecureRandom.alphanumeric(9) }

          before do
            visit action_items_path(format: :html)
            # 項目UIをクリックして編集画面に遷移
            click_on action_item.name
            # comboboxを開く
            find('input[role="combobox"]#action_item_action_tag_id').click
            # 不正なタグを入力
            find('input[role="combobox"]:visible').fill_in(with: invalid_random_action_tag_name)
          end

          it "該当の編集画面が表示されていること" do
            click_on "commit"
            expect(page).to have_current_path(edit_action_item_path(action_item.id))
          end

          it "エラーメッセージが表示されていること" do
            click_on "commit"
            expect(page).to have_content "タグ名は8文字以内で入力してください。"
          end
        end
      end
    end

    describe "項目の種類の更新" do
      context "「できそうかも/できなさそうかも」 -> 「躁状態の時にやらない方がいい行動」に更新した場合" do
        before do
          visit action_items_path(format: :html)
          # 項目UIをクリックして編集画面に遷移
          click_on action_item.name
          select "躁状態の時にやらない方がいい行動", from: "action_item[behavior_type]"
        end

        it "/action_items.htmlにリダイレクトされること" do
          click_on "commit"
          expect(page).to have_current_path(action_items_path(format: :html))
        end

        it "「やらない方がいい」リスト内で更新した項目が表示されていること" do
          click_on "commit"
          find("#switch-unenable-and-avoid-lists-icon").click
          within("#avoid-list") do
            expect(page).to have_content action_item.name
          end
        end

        it "「できるかも/できないかも」リスト内に項目が表示されていないこと" do
          click_on "commit"
          find("#switch-unenable-and-avoid-lists-icon").click
          within("#can-list") do
            expect(page).not_to have_content action_item.name
          end
          find("#switch-unenable-and-avoid-lists-icon").click
          within("#cannot-list") do
            expect(page).not_to have_content action_item.name
          end
        end
      end

      context "「躁状態の時にやらない方がいい行動」 -> 「できそうかも/できなさそうかも」に更新した場合" do
        let!(:avoid_action_item) { create(:action_item, name: "やらない方がいい行動", behavior_type: "avoid", user: user, action_tag: action_tag) }

        before do
          visit action_items_path(format: :html)
          find("#switch-unenable-and-avoid-lists-icon").click
          # 項目UIをクリックして編集画面に遷移
          click_on avoid_action_item.name
          select "できそうかも/できなさそうかも", from: "action_item[behavior_type]"
        end

        it "/action_items.htmlにリダイレクトされること" do
          click_on "commit"
          expect(page).to have_current_path(action_items_path(format: :html))
        end

        it "できそうかもリスト内で表示されていること" do
          click_on "commit"
          within("#can-list") do
            expect(page).to have_content avoid_action_item.name
          end
        end

        it "躁状態の時にやらない方がいいリスト内で表示されていないこと" do
          click_on "commit"
          find("#switch-unenable-and-avoid-lists-icon").click
          within("#avoid-list") do
            expect(page).not_to have_content avoid_action_item.name
          end
        end
      end
    end
  end
end
