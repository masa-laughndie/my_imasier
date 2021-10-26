class CreateDownloadRightsGrantings < ActiveRecord::Migration[6.1]
  def change
    create_table :download_rights_grantings do |t|
      t.integer :right_count,           null: false
      t.integer :interval_number,       null: false
      t.string  :interval_unit,         null: false
      t.integer :valid_duration_number, null: false
      t.string  :valid_duration_unit,   null: false

      t.timestamps
    end
  end
end
