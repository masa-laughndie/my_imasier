class License < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_one :contracting

  validates :user,                           presence: true
  validates :plan,                           presence: true
  validates :exercisable_from,               presence: true
  validates :exercisable_to,                 presence: true
  validates :download_right_flexible_digest, presence: true
  validate  :exercisable_from_must_greater_than_exercisable_to

  attribute :download_right_flexible_digest, :string, default: -> { SecureRandom.hex(16) }

  private

  def exercisable_from_must_greater_than_exercisable_to
    return if exercisable_from <= exercisable_to

    errors.add(:exercisable_from, :must_greater_then_exercisable_to)
  end
end
