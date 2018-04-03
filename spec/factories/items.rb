FactoryBot.define do
  factory :item, class: Spire::Item do
    sequence(:id) {|n| n}
    whse "00"
    part_no {Faker::Internet.password}
    description {Faker::Lorem.paragraph}
    type "N"
    status 0
    lot_numbered true
    serialized true
    available_qty {Faker::Number.between(1, 20)}
    on_hand_qty {Faker::Number.between(1, 20)}
    committed_qty {Faker::Number.between(1, 20)}
    backorder_qty {Faker::Number.between(1, 20)}
    on_purchase_qty 1
    foreground_color 0
    background_color 16777215
    primary_vendor {{
      id: Faker::Number.between(1, 99999999),
      vendorNo: Faker::Lorem.word,
      name: Faker::Company.name
    }}
    current_po_no {Faker::Number.number(5)}
    po_due_date {Faker::Date.forward(5)}
    reorder_point {Faker::Lorem.word}
    minimum_buy_qty 1
    current_cost {Faker::Commerce.price}
    average_cost {Faker::Commerce.price}
    standard_cost {Faker::Commerce.price}
    buy_measure_code {Faker::Number.number(5)}
    stock_measure_code {Faker::Number.number(5)}
    sell_measure_code {Faker::Number.number(5)}
    alternate_part_no {Faker::Number.number(5)}
    accessory_whse "00001"
    accessory_part_no {Faker::Number.number(10)}
    product_code {Faker::Number.number(10)}
    group_no {Faker::Number.number(10)}
    sales_dept "Sales"
    user_def1 nil
    user_def2 nil
    discountable true
    weight {Faker::Measurement.weight}
    pack_size {Faker::Lorem.word}
    allow_back_orders true
    allow_returns true
    duty_pct {Faker::Number.between(1, 10)}
    freight_pct {Faker::Number.between(1, 10)}
    manufacture_country {Faker::Address.country}
    harmonized_code {Faker::Lorem.word}
    extended_description {Faker::Lorem.paragraph}
    unit_of_measures {{
      EA: {
        code: "EA",
        description: "",
        upc: nil,
        location: "",
        weight: "0",
        buyUOM: true,
        sellUOM: true,
        allowFractionalQty: true,
        quantityFactor: "1",
        directFactor: true
      }
    }}
    pricing {{
      EA: {
        sellPrices: [
          Faker::Number.between(1, 2999),
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0,
          0
        ]
      }
    }}
    images []
    default_expiry_date {Faker::Date.forward(10)}
    lot_consume_type {Faker::Lorem.word}
    upload false
  end
end