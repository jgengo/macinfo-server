class Client < ApplicationRecord
    belongs_to :os, optional: true

    has_many :clients_sensors,  dependent:  :destroy
    has_many :sensors,          through:    :clients_sensors

    has_many :clients_devices,  dependent:  :destroy
    has_many :devices,          through:    :clients_devices

    has_many :locations,        dependent: :destroy

    validates_uniqueness_of :hostname
    validates_presence_of   :hostname
    validates_presence_of   :uuid

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
            @sensor  = Sensor.find_or_create_by!(name: sensor['name'])
            csensor = ClientsSensor.create!(sensor_id: @sensor.id, client_id: self.id, celsius: sensor['celsius'])
        end

        params[:usb_devices].each do |device|
            @device  = Device.find_or_create_by!(vendor: device['vendor'], model: device['model'])
            cdevice = ClientsDevice.create!(device_id: @device.id, client_id: self.id)
        end
    end

end
