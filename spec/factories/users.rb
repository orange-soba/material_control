FactoryBot.define do
  factory :user do
    name                  { Faker::Company.name }
    email                 { Faker::Internet.email }
    password              { Faker::Lorem.characters(number: 10, min_alpha: 1, min_numeric: 1) }
    password_confirmation { password }
    post_code             { '123-4567' }
    prefecture_id         { 1 }
    city                  { '蒲郡市一町どこそこ' }
    house_number          { '1-1' }
    building              { '大きなビル' }
    phone_number          { '0123-456-789' }
  end
end
