class DownloadRightsPacking < ApplicationRecord
  belongs_to :plan
  belongs_to :download_rights_granting

  validates :plan,                     presence: true
  validates :download_rights_granting, presence: true
  validates :grant_order,              presence: true, uniqueness: { scope: [:plan, :download_rights_granting] }

  class << self
    def execute_single_type!(_plan, _download_rights_granting)
      pack_number = _plan.contract_duration / _download_rights_granting.interval
      unless pack_number.positive?
        raise "plan contract duration must greater then or equeal to download rights granting interval"
      end

      packs = pack_number.times.map do |n|
        DownloadRightsPacking.new(
          plan: _plan,
          download_rights_granting: _download_rights_granting,
          grant_order: n + 1
        )
      end

      DownloadRightsPacking.import!(packs)
    end
  end
end
