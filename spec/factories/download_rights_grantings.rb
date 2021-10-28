FactoryBot.define do
  factory :download_rights_granting do
    right_count { 3 }
    interval_number { 1 }
    interval_unit { "months" }
    valid_duration_number { 1 }
    valid_duration_unit { "years" }

    trait :interval_1_months do
      interval_number { 1 }
      interval_unit { "months" }
    end

    trait :valid_1_years do
      valid_duration_number { 1 }
      valid_duration_unit { "years" }
    end
  end
end
