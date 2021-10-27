class CreateContractings < ActiveRecord::Migration[6.1]
  def change
    create_table :contractings do |t|
      t.references :user,           null: false, foreign_key: true
      t.references :license,        null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.integer    :price,          null: false
      t.datetime   :contracted_at,  null: false

      t.timestamps
    end
  end
end
