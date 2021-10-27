class DownloadRight < ApplicationRecord
  belongs_to :license

  validates :license,     presence: true
  validates :valid_from,  presence: true
  validates :valid_to,    presence: true
  validates :right_count, presence: true
end
