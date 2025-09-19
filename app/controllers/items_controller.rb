class ItemsController < ApplicationController
  before_action :authenticate_user!, only: :new

  def index
  end

  def new
    # 商品出品フォームで使うためのItemモデルのインスタンスを生成
    @item = Item.new
  end
end
