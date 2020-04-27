class CreateSyncs < ActiveRecord::Migration[6.0]
  def change
    create_table :syncs do |t|
      t.string :hostname
      t.json :data

      t.timestamps
    end
  end
end
