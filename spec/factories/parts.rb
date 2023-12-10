FactoryBot.define do
  factory :part do
    name { Faker::Commerce.product_name }
    stock { Faker::Number.number(digits: 4) }
    finished { false }

    association :user
  end
end