FactoryBot.define do
  factory :purchase_address do
    token              { 'tok_abcdefg' }
    postal_code        { '123-4567' }
    prefecture_id      { Faker::Number.between(from: 2, to: 48) }
    city               { Faker::Address.city }
    street_address     { Faker::Address.street_address }
    building_name      { Faker::Address.secondary_address }
    phone_number       { Faker::Number.leading_zero_number(digits: 11) }
  end
end
