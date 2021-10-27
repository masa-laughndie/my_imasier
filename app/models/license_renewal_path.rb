class LicenseRenewalPath < ApplicationRecord
  belongs_to :from_license, class_name: "License"
  belongs_to :to_license, class_name: "License"

  validates :from_license, presence: true
  validates :to_license,   presence: true, uniqueness: { scope: :from_license }
  validate :from_license_must_precede_to_license

  private

  def from_license_must_precede_to_license
    return if from_license == to_license
    return unless from_license.exercisable_to && to_license.exercisable_from
    return if from_license.exercisable_to <= to_license.exercisable_from

    errors.add(:from_license, :must_precede_to_license)
  end
end
