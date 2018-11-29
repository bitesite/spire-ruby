FactoryBot.define do
  factory :upc, class: Spire::Upc do
    sequence(:upc) {|n| n}
    uom_code "EA"
    inventory {{
      id: Faker::Number.between(1, 99999999)
    }}
  end
end