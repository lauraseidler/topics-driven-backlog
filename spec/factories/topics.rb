FactoryBot.define do
  factory :topic do
    title { Faker::StarWars.planet }
    url { Faker::Internet.url }
    course_id nil
  end
end