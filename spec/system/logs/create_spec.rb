require 'rails_helper'

RSpec.describe "Create", type: :system do
  describe '記録作成機能' do
    context '記録の作成に成功した場合' do
      it '成功を知らせるフラッシュメッセージが表示されること' do 
        visit new_log_path
        click_on '記録する'
        expect(page).to have_current_path(new_log_path)
        expect(page).to have_content '記録の作成が完了しました。'
      end
    end

    context '記録の作成に失敗した場合' do
      it '失敗を知らせるフラッシュメッセージが表示されること' do
        visit new_log_path
        click_on '記録する'
        expect(page).to have_current_path(new_log_path)
        expect(page).to have_content '記録の作成に失敗しました。'
      end
    end
  end
end
