class Plan < ApplicationRecord
  TIME_UNITS = %w(days months years).freeze

  has_many :download_rights_packings, -> { order(grant_order: :asc)},
                                      dependent: :destroy
  has_many :download_rights_grantings, through: :download_rights_packings
  has_many :licenses

  validates :price,                        presence: true
  validates :contract_duration_number,     presence: true, numericality: { only_integer: true }
  validates :contract_duration_unit,       presence: true, inclusion: { in: TIME_UNITS }
  validates :seats_count,                  presence: true, numericality: { only_integer: true }

  def contract_duration
    contract_duration_number.__send__(contract_duration_unit.to_sym)
  end
end
