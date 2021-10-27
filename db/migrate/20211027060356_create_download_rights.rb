class CreateDownloadRights < ActiveRecord::Migration[6.1]
  def change
    create_table :download_rights do |t|
      t.references :license, null: false, foreign_key: true
      t.datetime   :valid_from, null: false
      t.datetime   :valid_to, null: false
      t.integer    :right_count, null: false

      t.timestamps
    end
  end
end
