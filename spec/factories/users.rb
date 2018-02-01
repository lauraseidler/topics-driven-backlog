include DomainDefinition

FactoryBot.define do
  factory :user do
    email { "#{Faker::Internet.user_name}@#{ENV['ORGANISATION_DOMAIN']}" }
    role {User.roles[:instructor]}
  end
end
