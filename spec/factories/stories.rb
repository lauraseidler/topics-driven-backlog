FactoryBot.define do
  factory :story do
    title { Faker::Lorem.word }
    description { Faker::Lorem.word }
    identifier nil
  end
end