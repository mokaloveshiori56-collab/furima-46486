FactoryBot.define do
  factory :item do
    item_name { "MyString" }
    item_description { "MyText" }
    category_id { 1 }
    item_condition_id { 1 }
    shipping_fee_burden_id { 1 }
    prefecture_id { 1 }
    days_to_ship_id { 1 }
    price { 1 }
    user { nil }
  end
end
