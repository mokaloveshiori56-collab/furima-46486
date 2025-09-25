require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    sign_in @user
  end

  describe 'GET #index' do
    it '購入ページにアクセスできること' do
      get :index, params: { item_id: @item.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    context '購入が成功する場合' do
      it '必要な情報を適切に入力すると、購入が完了すること' do
        purchase_params = FactoryBot.attributes_for(:purchase_address, user_id: @user.id, item_id: @item.id)
        expect do
          post :create, params: { item_id: @item.id, purchase_address: purchase_params }
        end.to change(PurchaseRecord, :count).by(1).and change(Address, :count).by(1)
      end
    end

    context '購入が失敗する場合' do
      it 'トークンが空では購入が失敗すること' do
        purchase_params = FactoryBot.attributes_for(:purchase_address, token: '', user_id: @user.id, item_id: @item.id)
        expect do
          post :create, params: { item_id: @item.id, purchase_address: purchase_params }
        end.to_not change(PurchaseRecord, :count)
        expect(response).to render_template(:index)
      end
    end
  end
end
