class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :update, :destroy]

  def index
    @items = Item.all.order('created_at DESC')
  end

  def show
  end

  def edit
  end

  def destroy
    @item.destroy
    redirect_to root_path, notice: '商品を削除しました'
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '商品を出品しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    return if @item.user == current_user

    redirect_to root_path
  end

  def item_params
    params.require(:item).permit(
      :item_name, :item_description, :category_id, :item_condition_id,
      :shipping_fee_burden_id, :prefecture_id, :days_to_ship_id, :price, :image
    ).merge(user_id: current_user.id)
  end
end
