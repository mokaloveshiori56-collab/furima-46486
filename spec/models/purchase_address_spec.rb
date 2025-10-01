require 'rails_helper'

RSpec.describe PurchaseAddress, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @purchase_address = FactoryBot.build(:purchase_address, user_id: @user.id, item_id: @item.id)
  end

  describe '購入情報の保存' do
    context '購入ができる場合' do
      it 'すべての情報が正しく入力されていれば保存できること' do
        expect(@purchase_address).to be_valid
      end
    end

    context '購入ができない場合' do
      it 'user_idが空では保存できないこと' do
        @purchase_address.user_id = nil
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが空では保存できないこと' do
        @purchase_address.item_id = nil
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include("Item can't be blank")
      end

      it 'tokenが空では保存できないこと' do
        @purchase_address.token = nil
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include("Token can't be blank")
      end

      it '郵便番号が空では保存できないこと' do
        @purchase_address.postal_code = nil
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include("Postal code can't be blank", 'Postal code is invalid')
      end

      it '郵便番号が「3桁ハイフン4桁」の形式でなければ保存できないこと' do
        @purchase_address.postal_code = '1234567'
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include('Postal code is invalid')
      end

      it '都道府県が「---」では保存できないこと' do
        @purchase_address.prefecture_id = 1
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include('Prefecture must be other than 1')
      end

      it '市区町村が空では保存できないこと' do
        @purchase_address.city = nil
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include("City can't be blank")
      end

      it '番地が空では保存できないこと' do
        @purchase_address.street_address = nil
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include("Street address can't be blank")
      end

      it '電話番号が空では保存できないこと' do
        @purchase_address.phone_number = nil
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include("Phone number can't be blank")
      end

      it '電話番号が10桁未満では保存できないこと' do
        @purchase_address.phone_number = '123456789'
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include('Phone number is invalid')
      end

      it '電話番号が12桁以上では保存できないこと' do
        @purchase_address.phone_number = '123456789012'
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include('Phone number is invalid')
      end

      it '電話番号にハイフンが含まれていると保存できないこと' do
        @purchase_address.phone_number = '090-1234-5678'
        @purchase_address.valid?
        expect(@purchase_address.errors.full_messages).to include('Phone number is invalid')
      end
    end
  end
end
