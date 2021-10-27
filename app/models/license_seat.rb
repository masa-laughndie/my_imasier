class LicenseSeat < ApplicationRecord
  belongs_to :license
  belongs_to :user
  has_many :downloadings

  validates :license,     presence: true
  validates :user,        presence: true
  validates :assigned_at, presence: true
  validate :seats_count_must_be_within_limit

  scope :being_assigned, -> { where(unassigned_at: nil) }

  attribute :assigned_at, :datetime, default: -> { Time.current }

  private

  def seats_count_must_be_within_limit
    return if license.seats_count >= license.seats.being_assigned.count

    errors.add(:seats_count, :must_be_within_limit)
  end
end
