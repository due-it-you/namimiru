require 'rails_helper'

RSpec.describe "Signup", type: :system do
  describe 'ユーザー新規登録' do
    context 'フォームの入力値が正常' do
      it 'ユーザーの新規作成が成功する' do
        visit new_user_registration_path
        fill_in 'name', with: '松永 拓朗'
        fill_in 'email', with: 'polarbear1001@gmail.com'
        fill_in 'password', with: 'G473888g!'
        fill_in 'password_confirmation', with: 'G473888g!'
        click_on '送信'
        expect(page).to have_content('新規登録が完了しました。')
        expect(page).to have_current_path('/logs/new')
      end
    end
  end
end
