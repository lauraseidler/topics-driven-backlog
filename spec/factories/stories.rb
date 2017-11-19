FactoryBot.define do
  factory :story do
    title { Faker::Lorem.word }
    description { Faker::Lorem.word }
    identifier nil
    status {rand(0..2)}
    points {[rand(1..3), nil].sample}
  end
end