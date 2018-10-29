FactoryBot.define do
  factory :order, class: Spire::Order do
    sequence(:id) {|n| n}
    order_no {Faker::Number.number(5)}
    customer {{"id"=>Faker::Number.number(5)}}
    address {{"streetAddress"=>Faker::Address.full_address()}}
    shipping_address {{"streetAddress"=>Faker::Address.full_address()}}
    items {[
        build(:item)
      ]}
    status "0"
    type "0"
    hold {false}
    order_date {Faker::Time.backward(10)}
    customer_po {Faker::Number.number(5)}
    fob "Origin"
    terms_code "02"
    terms_text {Faker::Business.credit_card_type}
    freight {Faker::Number.number(2)}
    taxes [
      {
        "code"=>3,
        "name"=>"H.S.T - 13%",
        "shortName"=>"HST",
        "rate"=>"13",
        "exemptNo"=>"",
        "total"=>0
      }
    ]
    subtotal {Faker::Commerce.price()}
    subtotal_ordered {Faker::Commerce.price()}
    discount 0
    total_discount 0
    total {Faker::Commerce.price()}
    total_ordered {Faker::Commerce.price()}
    gross_profit 0
    created_by {Faker::Name.initials()}
    modified_by {Faker::Name.initials()}
    created {Faker::Time.backward(1)}
    modified {Faker::Time.forward(1)}
  end
end