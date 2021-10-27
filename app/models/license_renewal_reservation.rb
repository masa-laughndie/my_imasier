class LicenseRenewalReservation < ApplicationRecord
  include AASM

  belongs_to :license
  belongs_to :renewal_plan, class_name: "Plan"

  aasm column: :status do
    state :reserved, initial: true
    state :canceled
    state :completed

    event :reserve do
      transitions from: :canceled, to: :reserved
    end

    event :cancel do
      transitions from: :reserved, to: :canceled
    end

    event :complete do
      transitions from: :reserved, to: :completed
    end
  end
end
