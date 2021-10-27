class User < ApplicationRecord
  has_many :contractings
  has_many :contracted_licenses, class_name: "License"
  has_many :license_seats
  # TODO: 現在有効ライセンス && assign 中の条件を追加する
  has_many :exercisable_licenses, through: :license_seats
end
