require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @item_owner = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, user: @item_owner)
    sign_in @user
  end

  describe 'GET #index' do
    it '購入ページにアクセスできること' do
      get :index, params: { item_id: @item.id }
      expect(response).to have_http_status(200)
    end
  end
  context '未ログイン状態の場合' do
    it '購入ページにアクセスできず、ログインページにリダイレクトされること' do
      sign_out @user # ユーザーをログアウト
      get :index, params: { item_id: @item.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context '売却済み商品にアクセスした場合' do
    it '購入ページにアクセスできず、トップページにリダイレクトされること' do
      # 商品に購入記録を作成し、売却済み状態にする
      FactoryBot.create(:purchase_record, item: @item)
      get :index, params: { item_id: @item.id }
      expect(response).to redirect_to(root_path)
    end
  end

  context '自身が出品した商品にアクセスした場合' do
    it '購入ページにアクセスできず、トップページにリダイレクトされること' do
      sign_in @item_owner # 出品者本人でログイン
      get :index, params: { item_id: @item.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST #create' do
    context '購入が成功する場合' do
      it '必要な情報を適切に入力すると、購入が完了し、DBに2つのレコードが作成されること' do
        purchase_params = FactoryBot.attributes_for(:purchase_address, user_id: @user.id, item_id: @item.id)
        expect do
          post :create, params: { item_id: @item.id, purchase_address: purchase_params }
        end.to change(PurchaseRecord, :count).by(1).and change(Address, :count).by(1)

        expect(response).to redirect_to(root_path)
      end

      context '購入が失敗する場合' do
        it 'トークンが空では購入が失敗し、フォームが再表示されること' do
          purchase_params = FactoryBot.attributes_for(:purchase_address, token: '', user_id: @user.id, item_id: @item.id)
          expect do
            post :create, params: { item_id: @item.id, purchase_address: purchase_params }
          end.to_not change(PurchaseRecord, :count)

          expect(response).to render_template(:index)
        end
      end

      it '電話番号が空では購入が失敗し、フォームが再表示されること' do
        purchase_params = FactoryBot.attributes_for(:purchase_address, phone_number: '', user_id: @user.id, item_id: @item.id)

        expect do
          post :create, params: { item_id: @item.id, purchase_address: purchase_params }
        end.to_not change(PurchaseRecord, :count)

        expect(response).to render_template(:index)
      end
    end
  end
end
