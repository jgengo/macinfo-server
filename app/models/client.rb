class Client < ApplicationRecord
	belongs_to :os, optional: true

	has_many :clients_sensors
	has_many :sensors, through: :clients_sensors

    has_secure_token
end
