FactoryBot.define do
  factory :configuration, class: Spire::Configuration do
    company 'BiteSite'
    username {Faker::Internet.user_name(nil, %w(. _ -))}
    password {Faker::Internet.password}
    host "www.#{Faker::Internet.domain_name}"
    port 3000
  end
end