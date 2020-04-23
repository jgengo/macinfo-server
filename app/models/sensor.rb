class Sensor < ApplicationRecord
	has_many :clients_sensors, 	dependent: 	:destroy
	has_many :clients, 			through: 	:clients_sensors
end
