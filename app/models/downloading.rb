class Downloading < ApplicationRecord
  belongs_to :download_right
  belongs_to :license_seat

  validates :download_right,          presence: true
  validates :license_seat,            presence: true
  validates :item_id,                 presence: true
  validates :downloaded_at,           presence: true
  validates :download_right_exercise, presence: true, inclusion: { in: [true, false] }
  validate :license_seat_must_not_be_unassigned
  validate :license_seat_must_be_within_valid_duration
  validate :download_right_must_be_exercisable

  scope :exercised, -> { where(download_right_exercise: true) }
  scope :not_exercised, -> { where(download_right_exercise: false) }

  attribute :downloaded_at, :datetime, default: -> { Time.current }

  class << self
    def do!(user:, license:, item_id:)
      seat = user.license_seats.within_exercisable_duration.being_assigned.last
      license.download_right_to_exercise.downloadings.create!(
        license_seat: seat,
        item_id: item_id,
        download_right_exercise: true # TODO: 再ダウンロード対応
      )
    end
  end

  private

  def license_seat_must_not_be_unassigned
    errors.add(:license_seat, :must_not_be_unassigned) if license_seat.unassigned?
  end

  def license_seat_must_be_within_valid_duration
    errors.add(:license_seat, :must_be_within_valid_duration) unless license_seat.within_exercisable_duration?
  end

  def download_right_must_be_exercisable
    errors.add(:license_seat, :must_not_be_unassigned) unless download_right.exercisable?
  end
end
