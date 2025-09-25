class OrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    @item = Item.find(params[:item_id])
    @purchase_address = PurchaseAddress.new
  end

  def create
    @item = Item.find(params[:item_id])
    @purchase_address = PurchaseAddress.new(purchase_params)
    if @purchase_address.valid?
      @purchase_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.require(:purchase_address).permit(
      :postal_code, :prefecture_id, :city, :street_address,
      :building_name, :phone_number, :token
    ).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
