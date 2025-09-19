require 'rails_helper'

RSpec.describe "Create", type: :system do
  describe '記録作成機能' do
    context '記録の作成に成功した場合' do
      it '成功を知らせるフラッシュメッセージが表示されること' do
        visit new_daily_record_path
        find_by_id('mood-range').set rand(-5..5)
        click_on '記録する'
        expect(page).to have_current_path(charts_path)
        expect(page).to have_content '記録の作成が完了しました。'
      end
    end

    context '記録の作成に失敗した場合' do
      before do
        # saveメソッドが実行される時に強制的にfalseを返して失敗させる
        allow_any_instance_of(DailyRecord).to receive(:save).and_return(false)
      end
      it '失敗を知らせるフラッシュメッセージが表示されること' do
        visit new_daily_record_path
        find_by_id('mood-range').set rand(-5..5)
        click_on '記録する'
        expect(page).to have_current_path(new_daily_record_path)
        expect(page).to have_content '記録の作成に失敗しました。'
      end
    end

    context 'すでに今日の記録の作成が完了している場合' do
      before do
        user = create(:user)
        create(:daily_record, user: user, created_at: Time.current)
        sign_in user
      end

      it 'すでに完了していることを知らせるメッセージが表示されていること' do
        visit new_daily_record_path
        expect(page).to have_content 'すでに今日の記録は作成済みです。'
      end
    end
  end
end
