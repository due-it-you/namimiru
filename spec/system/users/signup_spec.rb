require 'rails_helper'

RSpec.describe "Signup", type: :system do

  describe 'ユーザー新規登録' do
    # 正常系
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

    # 異常系
    context 'フォームの入力値が異常' do
      before do
        visit new_user_registration_path
        fill_in 'name', with: '松永 拓朗'
        fill_in 'email', with: 'polarbear1001@gmail.com'
        fill_in 'password', with: 'G473888g!'
        fill_in 'password_confirmation', with: 'G473888g!'
        click_on '送信'
      end

      context 'ユーザーネームのフィールドに何も入力されていない場合' do
        it '新規登録に失敗し、エラーメッセージが表示される' do
          fill_in 'name', with: ''
          click_on '送信'
          expect(page).to have_content('ユーザーネームを入力してください。')
          expect(page).to have_current_path(new_user_registration_path)
        end
      end

      context 'ユーザーネームが13文字以上の場合' do
        it '新規登録に失敗し、エラーメッセージが表示される' do
          fill_in 'name', with: 'ひらかたチャンネルの３号！'
          click_on '送信'
          expect(page).to have_current_path(new_user_registration_path)
          expect(page).to have_content('ユーザーネームは12文字以内にしてください。')
        end
      end
    end
  end
end
