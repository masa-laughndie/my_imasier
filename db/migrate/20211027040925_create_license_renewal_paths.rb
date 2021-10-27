class CreateLicenseRenewalPaths < ActiveRecord::Migration[6.1]
  def change
    create_table :license_renewal_paths do |t|
      t.references :from_license, null: false, foreign_key: { to_table: :licenses }
      t.references :to_license,   null: false, foreign_key: { to_table: :licenses }

      t.timestamps
    end
  end
end
