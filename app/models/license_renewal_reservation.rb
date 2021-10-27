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

  def execute!
    ActiveRecord::Base.transaction do
      contracting = Contracting.do!(
        user: license.user,
        plan: renewal_plan,
        payment_method: license.contracting.payment_method,
        exercise_from: license.exercisable_to
      )

      renewal_license = contracting.license

      create_renewal_path!(renewal_license)
      # TODO: license 契約時の契約ユーザー追加をやめる
      # copy_seats!(renewal_license)

      complete!
    end
  end

  private

  def create_renewal_path!(renewal_license)
    paths = license.ancestral_licenses_and_itself.map do |ancestral_license|
      ancestral_license.paths_to_descendent_licenses_and_itself.build(
        from_license: ancestral_license,
        to_license: renewal_license
      )
    end

    LicenseRenewalPath.import!(paths)
  end

  def copy_seats!(renewal_license)
    copied_seats = license.seats.map do |seat|
      renewal_license.seats.build(user: seat.user, assigned_at: renewal_license.exercisable_from)
    end

    LicenseSeat.import!(copied_seats)
  end
end
