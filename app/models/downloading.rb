class Downloading < ApplicationRecord
  belongs_to :download_right
  belongs_to :license_seat

  validates :download_right,          presence: true
  validates :license_seat,            presence: true
  validates :item_id,                 presence: true
  validates :downloaded_at,           presence: true
  validates :download_right_exercise, presence: true, inclusion: { in: [true, false] }

  attribute :downloaded_at, :datetime, default: -> { Time.current }
end
