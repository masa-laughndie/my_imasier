class Contracting < ApplicationRecord
  belongs_to :user
  belongs_to :license
  belongs_to :payment_method

  validates :price,         presence: true
  validates :contracted_at, presence: true

  attribute :contracted_at, :datetime, default: -> { Time.current }

  class << self
    def do!(user:, plan:, payment_method:)
      license = License.new(
        user: user,
        plan: plan,
        exercisable_from: Time.current,
        exercisable_to: Time.current + plan.contract_duration,
      )
      contracting = Contracting.new(
        user: user,
        license: license,
        payment_method: payment_method,
        price: plan.price,
      )
      contracting.save!
    end
  end
end
