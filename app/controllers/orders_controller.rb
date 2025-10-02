class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create]
  before_action :set_item, only: [:index, :create]
  before_action :check_item_status, only: [:index, :create]

  def index
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
    @purchase_address = PurchaseAddress.new
  end

  def create
    # フォームオブジェクトの初期化と同時に、user_idとitem_idをマージ
    @purchase_address = PurchaseAddress.new(purchase_params)

    if @purchase_address.valid?
      # 1. 決済を実行
      pay_item 
      
      # 2. 決済成功後にのみ、データベースへの保存を実行
      #    saveメソッド内でトランザクションが実行される PurchaseAddress モデルの設計を想定
      @purchase_address.save 
      
      redirect_to root_path, notice: '商品を購入しました。' # 成功時のメッセージを追加
    else
     # 🚨 このメッセージがターミナルに表示されます 🚨
    puts "=================================================="
    puts "バリデーションエラー:"
    @purchase_address.errors.full_messages.each do |message|
      puts "- #{message}"
    end
    puts "=================================================="

    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
    render :index, status: :unprocessable_entity
    end

  # Payjp::CardError（カード情報エラー）以外の予期せぬ決済エラーもここでキャッチ
  rescue Payjp::PayjpError => e 
    Rails.logger.error "Payjp Error: #{e.message}"
    @purchase_address.errors.add(:base, '決済処理中に予期せぬエラーが発生しました。')
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
    render :index, status: :unprocessable_entity
  end

  private

  def set_item
    # find_byではなくfindを使い、見つからない場合は404エラーにするのがRailsの慣習
    @item = Item.find(params[:item_id])
    # redirect_to root_path unless @item は不要になる（findでエラーになるため）
  end

  def check_item_status
    # 自分の出品した商品を購入しようとしている場合、または商品がすでに購入済みの場合
    if @item.user_id == current_user.id || @item.purchase_record.present?
      redirect_to root_path
    end
  end

  def pay_item
    # PayjpのAPIキーをセット
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']

    Payjp::Charge.create(
      amount: @item.price, # 商品の価格（テーブルから取得）
      card: @purchase_address.token, # フォームオブジェクトからトークンを取得
      currency: 'jpy'
    )
  end

  def purchase_params
    # user_idとitem_idはStrong Parametersの外部でマージすることでセキュリティを確保しつつ、
    # フォームオブジェクトに必要な属性を渡すという設計は適切です。
    params.require(:purchase_address).permit(
      :postal_code, :prefecture_id, :city, :street_address,
      :building_name, :phone_number, :token
    ).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
