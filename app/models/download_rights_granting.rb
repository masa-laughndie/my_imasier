class DownloadRightsGranting < ApplicationRecord
  TIME_UNITS = %w(days months years).freeze

  has_many :download_rights_packings, dependent: :destroy
  has_many :plans, -> { distinct },
                   through: :download_rights_packings

  composed_of :interval,
              class_name: 'Duration',
              mapping: [%w[interval_number number], %w[interval_unit unit]],
              converter: :build

  composed_of :valid_duration,
              class_name: 'Duration',
              mapping: [%w[valid_duration_number number], %w[valid_duration_unit unit]],
              converter: :build

  validates :right_count,           presence: true, numericality: { only_integer: true }
  validates :interval_number,       presence: true, numericality: { only_integer: true }
  validates :interval_unit,         presence: true, inclusion: { in: TIME_UNITS }
  validates :valid_duration_number, presence: true, numericality: { only_integer: true }
  validates :valid_duration_unit,   presence: true, inclusion: { in: TIME_UNITS }

  def max_carryover_number
    (valid_duration / interval) - 1
  end

  def max_carryover_right_count
    max_carryover_number * right_count
  end

  def carryoverable?
    max_carryover_number.positive?
  end
end
