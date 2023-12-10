FactoryBot.define do
  factory :need_material do
    length         { Faker::Number.positive(from: 1.0, to: 4000.0) }
    length_option  { Faker::Number.positive(from: 1.0, to: 4000.0) }
    necessary_nums { Faker::Number.within(range: 1..100) }

    association :user
    association :part
  end
end
