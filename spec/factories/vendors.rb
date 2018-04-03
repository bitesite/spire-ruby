FactoryBot.define do
  factory :vendor, class: Spire::Vendor do
    sequence(:id) {|n| n}
    vendor_no {Faker::Number.number(5)}
    code {Faker::Number.number(5)}
    name {Faker::Company.name}
    hold false
    status 'A'
    address {{}}
    shipping_addresses []
    payment_terms {{}}
    currency "CAD"
    foreground_color 0
    background_color 16777215
  end
end