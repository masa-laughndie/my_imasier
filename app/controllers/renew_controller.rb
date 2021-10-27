class RenewController < ApplicationController
  # RenewSubscriptions#renew
  def execute
    licenses = License.join(:renewal_reservation).merge(LicenseRenewalReservation.to_execute)

    licenses.each do |license|
      license.renew!
    end
  end
end
