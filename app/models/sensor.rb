class Sensor < ApplicationRecord
	has_many :clients_sensors
	has_many :clients, through: :clients_sensors
end
