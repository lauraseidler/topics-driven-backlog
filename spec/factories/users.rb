FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password(8, 20, true, true) }
  end
end
