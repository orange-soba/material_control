FactoryBot.define do
  factory :user do
    name                  { Faker::Company.name }
    password              { Faker::Lorem.characters(number: 10, min_alpha: 1, min_numeric: 1) }
    password_confirmation { password }
  end
end
