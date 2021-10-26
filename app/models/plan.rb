class Plan < ApplicationRecord
  TIME_UNITS = %w(days months years).freeze

  has_many :download_rights_packings, -> { order(grant_order: :asc)},
                                      dependent: :destroy
  has_many :download_rights_grantings, through: :download_rights_packings

  composed_of :contract_duration,
              class_name: 'Duration',
              mapping: [%w[contract_duration_number number], %w[contract_duration_unit unit]],
              converter: :build

  validates :price,                        presence: true
  validates :contract_duration_number,     presence: true, numericality: { only_integer: true }
  validates :contract_duration_unit,       presence: true, inclusion: { in: TIME_UNITS }
  validates :seats_count,                  presence: true, numericality: { only_integer: true }
end
