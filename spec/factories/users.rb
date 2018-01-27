include DomainDefinition

FactoryBot.define do
  factory :user do
    email { "#{Faker::Internet.user_name}@#{ENV['ORGANISATION_DOMAIN']}" }
  end
end
