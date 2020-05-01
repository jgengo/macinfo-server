class Sensor < ApplicationRecord
	has_many :clients_sensors, 	dependent: 	:destroy
	has_many :clients, 			through: 	:clients_sensors

	def self.last_sync(client)
		last_sync = Sync.where(hostname: client.hostname).order(:created_at).last.created_at
		client.sensors.where('clients_sensors.created_at >= ?', last_sync).select(:model).as_json(except: [:id, :vendor])
	end
end
