FactoryBot.define do
  factory :material do
    material_type { Faker::Science.element }
    category      { Faker::Science.modifier }
    thickness     { Faker::Number.number(digits: 3) }
    width         { Faker::Number.number(digits: 3) }
    option        { Faker::Lorem.word }
    length        { Faker::Number.number(digits: 4) }
    stock         { Faker::Number.positive(from: 0.0, to: 2000.0) }
    material_id   { Faker::Number.number(digits: 2) }

    association :user
  end
end