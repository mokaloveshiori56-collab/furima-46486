FactoryBot.define do
  factory :item do
    association :user # ItemモデルがUserモデルに属することを定義
    
    # バリデーションに合う適切な値を設定
    item_name              { Faker::Commerce.product_name }
    item_description       { Faker::Lorem.sentence }
    category_id            { 2 } # 初期値1以外
    item_condition_id      { 2 } # 初期値1以外
    shipping_fee_burden_id { 2 } # 初期値1以外
    prefecture_id          { 2 } # 初期値1以外
    days_to_ship_id        { 2 } # 初期値1以外
    price                  { Faker::Number.between(from: 300, to: 9_999_999) }

    # テスト用の画像を添付
    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end