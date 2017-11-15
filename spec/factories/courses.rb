FactoryBot.define do
  factory :course do
    title { Faker::Lorem.word }
    hyperlink { Faker::Internet.url }
    start_date { Faker::Date.between(20.days.ago, Date.today) }
    end_date { Faker::Date.between(Date.tomorrow, 20.days.from_now) }
  end
end