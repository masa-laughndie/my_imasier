class DownloadRightsPacking < ApplicationRecord
  belongs_to :plan
  belongs_to :download_rights_granting

  validates :plan,                     presence: true
  validates :download_rights_granting, presence: true
  validates :grant_order,              presence: true, uniqueness: { scope: [:plan, :download_rights_granting] }
  validate  :contract_duration_must_greater_than_or_equeal_download_rights_granting_interval

  class << self
    def execute_single_type!(_plan, _download_rights_granting)
      pack_number = _plan.contract_duration / _download_rights_granting.interval

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

  private

  def contract_duration_must_greater_than_or_equeal_download_rights_granting_interval
    unless (plan.contract_duration / download_rights_granting.interval).positive?
      errors.add(:plan, :contract_duration_must_greater_than_or_equeal_download_rights_granting_interval)
    end
  end
end
