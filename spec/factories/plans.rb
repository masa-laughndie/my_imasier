FactoryBot.define do
  factory :plan do
    price { 3_300 }
    contract_duration_number { 1 }
    contract_duration_unit { "months" }
    seats_count { 1 }
  end
end
