RSpec.describe "CareRelationsDestroy", type: :system do
  describe "連携解除機能" do
    let(:user) { create(:user) }
    let(:connected_user) { create(:user) }

    context "連携解除に成功した場合" do

      before do
        sign_in user
        care_relation = CareRelation.create(supported_id: user.id, supporter_id: connected_user.id)
        visit care_relation_path(care_relation.id)
      end

      it "連携一覧画面にそのユーザーが表示されていないこと" do
        accept_confirm do
          click_link "trash-icon"  
        end
        expect(page).to have_content "連携の解除に成功しました！"
        expect(page).not_to have_content connected_user.name
      end
    end
  end
end
