class CreateDownloadRightsPackings < ActiveRecord::Migration[6.1]
  def up
    create_table :download_rights_packings do |t|
      t.references :plan,                     null: false, foreign_key: true
      t.references :download_rights_granting, null: false, foreign_key: true
      t.integer    :grant_order,              null: false

      t.timestamps
    end

    add_index  :download_rights_packings, [:plan_id, :download_rights_granting_id, :grant_order], unique: true, name: "index_download_rights_packings_for_single_order"
  end

  def down
    drop_table :download_rights_packings
  end
end
