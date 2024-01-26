FactoryBot.define do
  factory :user do
    name                  { Faker::Company.name }
    email                 { Faker::Internet.email }
    password              { Faker::Lorem.characters(number: 10, min_alpha: 1, min_numeric: 1) }
    password_confirmation { password }
    post_code             { rand(100..999).to_s + '-' + rand(1000..9999).to_s }
    prefecture_id         { rand(1..47) }
    city                  { Gimei.city.kanji + Gimei.town.kanji }
    house_number          { rand(1..999).to_s + '-' + rand(1..9999).to_s }
    building              { Faker::Lorem.word }
    phone_number          { Faker::PhoneNumber.cell_phone }
  end
end
