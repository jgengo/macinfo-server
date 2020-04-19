class CreateClientsSensors < ActiveRecord::Migration[6.0]
  def change
    create_table :clients_sensors do |t|
      t.references 		:sensor, 	null: false, foreign_key: true
      t.references 		:client, 	null: false, foreign_key: true
      t.integer 		:celsius, 	null: false
      t.timestamps
    end
  end
end
