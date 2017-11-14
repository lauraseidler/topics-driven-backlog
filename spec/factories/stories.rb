FactoryBot.define do
  factory :story do
    title { Faker::Lorem.word }
    description { Faker::Lorem.word }
    status {rand(0..2)}
  end
end