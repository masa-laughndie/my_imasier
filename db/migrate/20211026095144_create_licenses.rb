class CreateLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :licenses do |t|
      t.references :user,                           null: false, foreign_key: true
      t.references :plan,                           null: false, foreign_key: true
      t.datetime   :exercisable_from,               null: false
      t.datetime   :exercisable_to,                 null: false
      t.string     :download_right_flexible_digest, null: false

      t.timestamps
    end
  end
end
