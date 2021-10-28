FactoryBot.define do
  factory :plan do
    price { 3_300 }
    contract_duration_number { 1 }
    contract_duration_unit { "months" }
    seats_count { 1 }

    transient do
      download_rights_count { 3 }
      download_rights_interval { 1.month }
      download_rights_valid_duration { 1.years }
    end

    after(:create) do |plan, evaluator|
      #  TODO: もうちょいスッキリさせたい
      interval_number = evaluator.download_rights_interval.parts.values[0]
      interval_unit = evaluator.download_rights_interval.parts.keys[0]
      valid_duration_number = evaluator.download_rights_valid_duration.parts.values[0]
      valid_duration_unit = evaluator.download_rights_valid_duration.parts.keys[0]


      download_rights_granting = DownloadRightsGranting.find_by(
        right_count: evaluator.download_rights_count,
        interval_number: interval_number,
        interval_unit: interval_unit,
        valid_duration_number: valid_duration_number,
        valid_duration_unit: valid_duration_unit,
      ) || FactoryBot.create(
        :download_rights_granting,
        "interval_#{interval_number}_#{interval_unit}".to_sym,
        "valid_#{valid_duration_number}_#{valid_duration_unit}".to_sym,
        right_count: evaluator.download_rights_count,
      )

      DownloadRightsPacking.execute_single_type!(plan, download_rights_granting)
    end


    trait :contract_1_month do
      contract_duration_number { 1 }
      contract_duration_unit { "months" }
    end

    trait :contract_1_year do
      contract_duration_number { 1 }
      contract_duration_unit { "years" }
    end

    trait :single do
      seats_count { 1 }
    end

    trait :multi do
      seats_count { 5 }
    end
  end
end
