FactoryBot.define do
  factory :basic_auth_policy, class: Spire::Authorization::BasicAuthPolicy do
    username {Faker::Internet.user_name}
    password {Faker::Internet.password}
  end
end