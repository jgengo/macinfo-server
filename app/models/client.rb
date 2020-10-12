# require 'net/http'
# require 'uri'

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

    before_destroy :destroy_related_sync


    has_secure_token

    after_commit :call_cluster_map, if: -> { self.saved_change_to_active_user? }

    def uptime_to_date
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
            csensor = ClientsSensor.find_or_create_by!(sensor_id: @sensor.id, client_id: self.id)
            csensor.update(celsius: sensor['celsius'])
        end

        params[:usb_devices].each do |device|
            @device  = Device.find_or_create_by!(vendor: device['vendor'], model: device['model'])
            cdevice = ClientsDevice.create!(device_id: @device.id, client_id: self.id)
        end
    end

    def destroy_related_sync
        Sync.where(hostname: self.hostname).destroy_all
    end

    def call_cluster_map
        uri = URI('http://docker-1.hive.fi:5006/webhook/locations')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json', 'Authorization' => 'XXXXXXXXXXXXXXXX'})
        req.body = { hostname: self.hostname, login: self.active_user, kind: self.active_user != "" ? "create" : "close" }.to_json
        res = http.request(req)
        puts res.body
    end
end
