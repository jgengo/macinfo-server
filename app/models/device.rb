class Device < ApplicationRecord
	has_many :clients_devices, 	dependent: 	:destroy
	has_many :clients, 			through: 	:clients_devices

	validates_presence_of :model

	def self.last_sync(client)
		last_sync = Sync.where(hostname: client.hostname).order(:created_at).last.created_at
		client.devices.where('clients_devices.created_at >= ?', last_sync).select(:name, :celsius).as_json(except: :id)
	end
end
