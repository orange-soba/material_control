FactoryBot.define do
  factory :need_material do
    length         { Faker::Number.within(range: 1..4000) }
    length_option  { Faker::Lorem.word }
    necessary_nums { Faker::Number.within(range: 1..100) }
  end
end
