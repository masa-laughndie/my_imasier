class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.integer    :price,                    null: false
      t.integer    :contract_duration_number, null: false
      t.string     :contract_duration_unit,   null: false
      t.integer    :seats_count,              null: false

      t.timestamps
    end
  end
end
