class Device < ApplicationRecord
	has_many :clients_devices, 	dependent: 	:destroy
	has_many :clients, 			through: 	:clients_devices

	validates_presence_of :model
end
