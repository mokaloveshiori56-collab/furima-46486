class OrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    @item = Item.find(params[:item_id])
    @purchase_address = PurchaseAddress.new

    gon.payjp_public_key = ENV['PAYJP_PUBLIC_KEY']
  end

  def create
    @item = Item.find(params[:item_id])
    @purchase_address = PurchaseAddress.new(purchase_params)
    if @purchase_address.valid?
      pay_item
      @purchase_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def pay_item
    # 秘密鍵を環境変数から取得
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price, # 商品の価格（テーブルから取得）
      card: purchase_params[:token], # JavaScriptから送られたトークンID
      currency: 'jpy'
    )
  end

  def purchase_params
    params.require(:purchase_address).permit(
      :postal_code, :prefecture_id, :city, :street_address,
      :building_name, :phone_number, :token
    ).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
