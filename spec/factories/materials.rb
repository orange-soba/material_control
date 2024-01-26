FactoryBot.define do
  factory :material do
    material_type { Faker::Science.element }
    category      { Faker::Science.modifier }
    thickness     { Faker::Number.within(range: 1..120) }
    width         { Faker::Number.within(range: 1..200) }
    option        { Faker::Lorem.word }
    length        { Faker::Number.within(range: 1..10000) }
    stock         { Faker::Number.positive(from: 0.0, to: 2000.0) }
    material_id   { Faker::Number.within(range: 1..1000) }
    order_destination { Faker::Lorem.word }

    association :user
  end
end