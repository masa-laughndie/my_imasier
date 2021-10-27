class CreateLicenseSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :license_seats do |t|
      t.references :license,       null: false, foreign_key: true
      t.references :user,          null: false, foreign_key: true
      t.datetime   :assigned_at,   null: false
      t.datetime   :unassigned_at

      t.timestamps
    end
  end
end
