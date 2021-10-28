class AddDefaultDownloadRightExerciseToDownloading < ActiveRecord::Migration[6.1]
  def change
    change_column :downloadings, :download_right_exercise, :boolean, default: false
  end
end
