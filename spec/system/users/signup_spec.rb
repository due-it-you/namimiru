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

      # ユーザーネーム
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

      # メールアドレス
      context 'メールアドレスのフィールドに何も入力されていない場合' do
        it '新規登録に失敗し、エラーメッセージが表示される' do
          fill_in 'email', with: ''
          click_on '送信'
          expect(page).to have_current_path(new_user_registration_path)
          expect(page).to have_content('メールアドレスを入力してください。')
        end
      end

      context 'メールアドレスに「@」が入力されていない場合' do
        it '新規登録に失敗し、エラーメッセージが表示される' do
          fill_in 'email', with: 'polarbeat1001gmail.com'
          click_on '送信'
          expect(page).to have_current_path(new_user_registration_path)
          expect(page).to have_content('メールアドレスの形式を満たしてください。')
        end
      end

      # パスワード
      context 'パスワードが入力されていない場合' do
        it '新規登録に失敗し、エラーメッセージが表示される' do
          fill_in 'password', with: ''
          fill_in 'password_confirmation', with: ''
          click_on '送信'
          expect(page).to have_current_path(new_user_registration_path)
          expect(page).to have_content('パスワードを入力してください。')
        end
      end

      context 'パスワードが8文字未満の場合' do
        it '新規登録に失敗し、エラーメッセージが表示される' do
          fill_in 'password', with: 'Hg6gggg'
          fill_in 'password_confirmation', with: 'Hg6gggg'
          click_on '送信'
          expect(page).to have_current_path(new_user_registration_path)
          expect(page).to have_content('パスワードは8文字以上にしてください。')
        end
      end

      context '英字小文字・英字大文字・数字がそれぞれ1つ以上含まれていない場合' do
        it '新規登録に失敗し、エラーメッセージが表示される' do
          fill_in 'password', with: 'h89977442xg'
          fill_in 'password_confirmation', with: 'h89977442xg'
          click_on '送信'
          expect(page).to have_current_path(new_user_registration_path)
          expect(page).to have_content('パスワードは、英字小文字・英字大文字・数字がそれぞれ1つ以上含まれるようにしてください。')
        end
      end
    end
  end
end
