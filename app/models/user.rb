class User < ApplicationRecord
  has_many :contractings
  has_many :contracted_licenses, class_name: "License"
  has_many :license_seats
  # TODO: 現在有効ライセンス && assign 中の条件を追加する
  has_many :exercisable_licenses, through: :license_seats, source: :license

  def assaign!(user, license)
    raise "asssign permission is required." unless has_assign_permission?(license)

    license.is_assigned!(user)
  end

  def unassaign!(user, license)
    raise "asssign permission is required." unless has_assign_permission?(license)

    license.is_unassigned!(user)
  end

  private

  def has_assign_permission?(license)
    self == license.user
  end
end
