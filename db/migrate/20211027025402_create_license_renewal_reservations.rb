class CreateLicenseRenewalReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :license_renewal_reservations do |t|
      t.references :license,      null: false, foreign_key: true, index: { unique: true }
      t.references :renewal_plan, null: false, foreign_key: { to_table: :plans }
      t.string     :status,       null: false

      t.timestamps
    end
  end
end
