class LicenseRenewalReservation < ApplicationRecord
  include AASM

  RENEWABLE_PERIOD = 3.days.freeze

  belongs_to :license
  belongs_to :renewal_plan, class_name: "Plan"

  validate :seats_count_must_not_be_reduced

  scope :to_execute, ->(time = Time.current) {
    reserved
      .joins(:license)
      .merge(
        License
          .exercisable_to_after(time + 1.minute)
          .exercisable_to_before(time + RENEWABLE_PERIOD)
          # .not_canceled <= TODO: 対応する
          # .not_suspended <= TODO: 対応する
      )
  }

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
        exercise_from: license.exercisable_to,
        download_right_flexible_digest: license.download_right_flexible_digest,
      )

      renewal_license = contracting.license

      create_renewal_path!(renewal_license)
      copy_seats!(renewal_license)

      complete!
    end
  end

  # TODO: 更新可能なプランであるかのバリデーションを追加する
  def change_renewal_plan_to(new_renewal_plan)
    raise "can change renewal plan when only reserved" unless reserved?
    update!(renewal_plan: new_renewal_plan)
  end

  private

  def seats_count_must_not_be_reduced
    errors.add(:seats_count, :must_not_be_reduced) if renewal_plan.seats_count < license.seats_count
  end

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
