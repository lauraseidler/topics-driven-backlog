FactoryBot.define do
  factory :project do
    title { Faker::Name.unique.name }
    course_id nil
  end
end
