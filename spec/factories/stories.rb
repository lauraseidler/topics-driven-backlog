FactoryBot.define do
  factory :story do
    title { Faker::Lorem.word }
    description { Faker::Lorem.word }
    backlog_id nil
  end
end