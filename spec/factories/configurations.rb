FactoryBot.define do
  factory :configuration, class: Spire::Configuration do
    company {Faker::Company.name}
    username {Faker::Internet.user_name}
    password {Faker::Internet.password}
    host "www.#{Faker::Internet.domain_name}"
    port 3000
  end
end