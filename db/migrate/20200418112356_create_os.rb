class CreateOs < ActiveRecord::Migration[6.0]
  def change
    create_table :os do |t|
      t.references :client, null: false, foreign_key: true
      t.string :version
      t.string :build

      t.timestamps
    end
  end
end
