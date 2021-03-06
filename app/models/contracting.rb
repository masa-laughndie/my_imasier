class Contracting < ApplicationRecord
  belongs_to :user
  belongs_to :license
  belongs_to :payment_method

  validates :price,         presence: true
  validates :contracted_at, presence: true

  attribute :contracted_at, :datetime, default: -> { Time.current }

  class << self
    def do!(user:, plan:, payment_method:, exercise_from: Time.current, download_right_flexible_digest: SecureRandom.hex(16))
      license = License.new(
        user: user,
        plan: plan,
        exercisable_from: exercise_from,
        exercisable_to: exercise_from + plan.contract_duration,
        download_right_flexible_digest: download_right_flexible_digest,
      )
      contracting = Contracting.new(
        user: user,
        license: license,
        payment_method: payment_method,
        price: plan.price,
      )
      contracting.save!

      contracting
    end
  end
end
