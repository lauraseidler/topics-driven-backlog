FactoryBot.define do
  factory :course do
    title { Faker::Lorem.word }
    hyperlink { Faker::Internet.url }
    semester_type {
      [
          Course.semester_types[:summer],
          Course.semester_types[:winter]
      ].sample }
    semester_year { rand(2018..2050) }
  end
end