class Client < ApplicationRecord
	belongs_to :os, optional: true

	has_many :clients_sensors, 	dependent:  :destroy
	has_many :sensors, 			through: 	:clients_sensors

	validates_uniqueness_of :hostname
	validates_presence_of	:hostname
	validates_presence_of	:uuid

    has_secure_token

    def uptime_to_date()
    	Time.zone.now - self.uptime
    end

    def sync_save(params)
		os = Os.find_or_create_by!(version: params[:os_version][:version], build: params[:os_version][:build])
            
        client_info = {
            os_id: os.id,
            uptime: params[:uptime],
            active_user: params[:active_user],
            uuid: params[:uuid]
        }

        self.update(client_info)

        params[:sensors].each do |sensor|
            sensor = Sensor.find_or_create_by!(name: sensor['name'])

            cs = ClientsSensor.create!(sensor_id: sensor.id, client_id: self.id, celsius: sensor['celsius'])
        end
    end

end
