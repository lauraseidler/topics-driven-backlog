FactoryBot.define do
  factory :project do
    title { Faker::StarWars.planet }
    course_id nil
  end
end
