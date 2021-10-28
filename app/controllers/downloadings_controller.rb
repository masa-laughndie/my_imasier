class DownloadingsController < ApplicationController
  # items#complete action
  def create
    current_user = User.first
    license = current_user.exercisable_licenses.within_exercisable_duration.first
    item_id = rand(100_000)

    Downloading.do!(user: current_user, license: license, item_id: item_id)
  end
end
