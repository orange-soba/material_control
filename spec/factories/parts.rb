FactoryBot.define do
  factory :part do
    name { Faker::Commerce.product_name }
    stock { Faker::Number.number(digits: 4) }
    finished { rand(2) == 1 }

    association :user
  end
end