class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :client, null: false, foreign_key: true
      t.string :user
      t.datetime :begin_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
