class LicenseSeat < ApplicationRecord
  belongs_to :license
  belongs_to :user

  validates :license,     presence: true
  validates :user,        presence: true
  validates :assigned_at, presence: true

  scope :being_assigned, -> { where(unassigned_at: nil) }
end
