FactoryGirl.define do
  factory :story do
    title { Faker::Lorem.word }
    description { Faker::Lorem.word }
  end
end