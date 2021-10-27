class User < ApplicationRecord
  has_many :contractings
  has_many :licenses
end
