class CreateInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :infos do |t|
      t.references :client, null: false, foreign_key: true
      t.integer :uptime
      t.string :os_version
      t.string :os_version_build

      t.timestamps
    end
  end
end
