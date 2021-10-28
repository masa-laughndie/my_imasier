class DownloadRight < ApplicationRecord
  belongs_to :license
  has_many :downloadings

  validates :license,     presence: true
  validates :valid_from,  presence: true
  validates :valid_to,    presence: true
  validates :right_count, presence: true

  scope :within_valid_duration, ->(time = Time.current) { where(arel_table[:valid_from].lt(time)).where(arel_table[:valid_to].gt(time)) }
  scope :exercisable, ->(time = Time.current) { within_valid_duration(time).not_exercised }
  scope :sorted_by_valid_to, ->(order = :asc) { order(valid_to: order) }

  def within_valid_duration?(time = Time.current)
    valid_from < time && time < valid_to
  end

  def exercised?
    right_count <= downloadings.exercised.count
  end

  def not_exercised?
    !exercised?
  end

  def exercisable?(time = Time.current)
    within_valid_duration?(time) && not_exercised?
  end

  class << self
    def exercised
      exercised_right_ids = all.select(&:exercised?).map(&:id)
      DownloadRight.where(id: exercised_right_ids)
    end

    def not_exercised
      not_exercised_right_ids = all.select(&:not_exercised?).map(&:id)
      DownloadRight.where(id: not_exercised_right_ids)
    end
  end
end
