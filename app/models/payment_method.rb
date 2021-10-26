class PaymentMethod < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
