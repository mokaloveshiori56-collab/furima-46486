require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user) # FactoryBotを使用
  end

  describe 'ユーザー新規登録' do
    context '新規登録できる場合' do
      it '必要な情報を適切に入力すると、新規登録ができる' do
        expect(@user).to be_valid
      end
    end
    context '新規登録できない場合' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      # 他のバリデーションテストも同様に記述
    end
  end
end
