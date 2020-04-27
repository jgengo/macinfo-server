class CreateClientsDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :clients_devices do |t|
      t.references :device, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
