require 'rails_helper'

RSpec.describe "Signin", type: :system do
  describe 'ログイン機能' do
    context 'フォームの入力値が正常' do
      let(:user) { create(:user) }
      context 'usersテーブルにすでに存在するレコードを入力した場合' do
        it 'ログインに成功する' do
          visit new_user_session_path
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: user.password
          click_on 'ログイン'
          expect(page).to have_current_path(new_log_path)
          expect(page).to have_content 'ログインしました。'
        end
      end
    end
  end

  context 'フォームの入力値が異常' do
    context '登録されていないユーザーの情報を入力した場合' do
      it 'エラーメッセージが表示される' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: 'takedasoun@gmail.com'
        fill_in 'パスワード', with: 'Ghh111788'
        click_on 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end
end
