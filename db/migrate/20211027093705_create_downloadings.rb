class CreateDownloadings < ActiveRecord::Migration[6.1]
  def change
    create_table :downloadings do |t|
      t.references :download_right, null: false, foreign_key: true
      t.references :license_seat, null: false, foreign_key: true
      t.integer    :item_id
      t.datetime   :downloaded_at
      t.boolean    :download_right_exercise

      t.timestamps
    end
  end
end
