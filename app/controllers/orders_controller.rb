class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create]
  before_action :set_item, only: [:index, :create]
  before_action :check_item_status, only: [:index, :create]

  def index
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
    @purchase_address = PurchaseAddress.new
  end

  def create
    @purchase_address = PurchaseAddress.new(purchase_params)
    if @purchase_address.valid?
      pay_item
      @purchase_address.save
      redirect_to root_path
    else
      gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
      render :index, status: :unprocessable_entity
    end
  rescue Payjp::CardError
    # Payjpでの決済が失敗した場合（カード情報のエラーなど）
    @purchase_address.errors.add(:base, 'カード情報に誤りがあります。')
    render :index, status: :unprocessable_entity
  end

  private

  def set_item
    @item = Item.find_by(id: params[:item_id])
    redirect_to root_path unless @item
  end

  def check_item_status
    return unless @item.user_id == current_user.id || @item.purchase_record.present?

    redirect_to root_path
  end

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
