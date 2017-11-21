FactoryBot.define do
  factory :sprint do
    name { Faker::StarWars.planet }
    start_date { Faker::Date.between(20.days.ago, Date.today) }
    end_date { Faker::Date.between(Date.tomorrow, 20.days.from_now) }
    course_id nil
  end
end