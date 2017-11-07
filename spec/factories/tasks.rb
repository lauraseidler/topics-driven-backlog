FactoryBot.define do
  factory :task do
    title { Faker::StarWars.character }
    description { Faker::StarWars.character }
    story_id nil
  end
end