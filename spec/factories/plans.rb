FactoryBot.define do
  factory :plan do
    price { 3_300 }
    contract_duration_number { 1 }
    contract_duration_unit { "months" }
    seats_count { 1 }

    trait :contract_1_month do
      contract_duration_number { 1 }
      contract_duration_unit { "months" }
    end

    trait :contract_1_year do
      contract_duration_number { 1 }
      contract_duration_unit { "years" }
    end

    trait :with_download_rights_granting do
      after(:create) do |plan|
        _download_rights_granting = DownloadRightsGranting.first || FactoryBot.create(:download_rights_granting)
        DownloadRightsPacking.execute_single_type!(plan, _download_rights_granting)
      end
    end
  end
end
