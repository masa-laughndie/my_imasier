class LicenseSeat < ApplicationRecord
  belongs_to :license
  belongs_to :user
  has_many :downloadings

  validates :license,     presence: true
  validates :user,        presence: true
  validates :assigned_at, presence: true
  validate :seats_count_must_be_within_limit

  scope :being_assigned, -> { where(unassigned_at: nil) }
  scope :with_user, ->(user) { where(user: user) }
  scope :within_exercisable_duration, ->(time = Time.current) { joins(:license).merge(License.within_exercisable_duration(time)) }

  attribute :assigned_at, :datetime, default: -> { Time.current }

  delegate :within_exercisable_duration?, to: :license


  def being_assigned?
    !unassigned_at
  end

  def unassigned?
    !being_assigned?
  end

  private

  def seats_count_must_be_within_limit
    return if license.seats_count >= license.seats.being_assigned.count

    errors.add(:seats_count, :must_be_within_limit)
  end
end
