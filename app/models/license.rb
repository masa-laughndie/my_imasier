class License < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_one :contracting
  has_one :renewal_reservation, class_name: "LicenseRenewalReservation"
  has_many :paths_from_ancestral_licenses_and_itself, class_name: "LicenseRenewalPath", foreign_key: "to_license_id"
  has_many :paths_to_descendent_licenses_and_itself, class_name: "LicenseRenewalPath", foreign_key: "from_license_id"
  has_many :ancestral_licenses_and_itself, through: :paths_from_ancestral_licenses_and_itself, source: :from_license
  has_many :descendent_licenses_and_itself, through: :paths_to_descendent_licenses_and_itself, source: :to_license
  has_many :download_rights
  has_many :seats, class_name: "LicenseSeat"

  validates :user,                           presence: true
  validates :plan,                           presence: true
  validates :exercisable_from,               presence: true
  validates :exercisable_to,                 presence: true
  validates :download_right_flexible_digest, presence: true
  validate  :exercisable_from_must_greater_than_exercisable_to

  attribute :download_right_flexible_digest, :string, default: -> { SecureRandom.hex(16) }

  before_create :_build_renewal_reservation
  before_create :build_self_renewal_path
  before_create :build_download_rights

  def is_assigned!(user)
    seats.create!(user: user)
  end

  private

  def exercisable_from_must_greater_than_exercisable_to
    return if exercisable_from <= exercisable_to

    errors.add(:exercisable_from, :must_greater_then_exercisable_to)
  end

  # TODO: 自動更新可能かの判定を Plan に追加してそれによって実行するか決めるようにする
  def _build_renewal_reservation
    build_renewal_reservation(renewal_plan: plan)
  end

  def build_self_renewal_path
    paths_from_ancestral_licenses_and_itself.build(from_license: self)
  end

  def build_download_rights
    right_valid_from = exercisable_from
    plan.download_rights_grantings.each do |rights_grating|
      download_rights.build(
        valid_from: right_valid_from,
        valid_to: right_valid_from + rights_grating.valid_duration,
        right_count: rights_grating.right_count,
      )
      right_valid_from += rights_grating.interval
    end
  end
end
