class Sync < ApplicationRecord

	after_create :propagate_info 

	def propagate_info
		@client = Client.find_by(hostname: self.hostname)

		if @client and @client.token == self.data["token"]
			params = JSON.parse(self.data.to_json, symbolize_names: true)

			os = Os.find_or_create_by!(version: params[:os_version][:version], build: params[:os_version][:build])
            
			client_info = {
				os_id: os.id,
				uptime: params[:uptime],
				active_user: params[:active_user],
				uuid: params[:uuid]
			}
	
			@client.update(client_info)
	
			params[:sensors].each do |sensor|
				@sensor  = Sensor.find_or_create_by!(name: sensor[:name])
				csensor = ClientsSensor.find_or_create_by!(sensor_id: @sensor.id, client_id: @client.id)
				csensor.update(celsius: sensor[:celsius])
			end unless params[:sensors].blank?

			params[:usb_devices].each do |device|
				@device  = Device.find_or_create_by!(vendor: device[:vendor], model: device[:model])
				cdevice = ClientsDevice.create!(device_id: @device.id, client_id: @client.id)
			end unless params[:usb_devices].blank?
		end

	end

	def self.push_to_influxdb
		return unless Rails.env.production?
		c1_mac_alive = Sync.where('hostname like ? and created_at > ?', "c1%", Time.zone.now - 2.minutes).count('distinct hostname')
		c2_mac_alive = Sync.where('hostname like ? and created_at > ?', "c2%", Time.zone.now - 2.minutes).count('distinct hostname')
		c3_mac_alive = Sync.where('hostname like ? and created_at > ?', "c3%", Time.zone.now - 2.minutes).count('distinct hostname')

		c1_users_connected = Client.where('hostname like ?', "c1%").where.not(active_user: "").count
		c2_users_connected = Client.where('hostname like ?', "c2%").where.not(active_user: "").count
		c3_users_connected = Client.where('hostname like ?', "c3%").where.not(active_user: "").count

		mac_alive = c1_mac_alive + c2_mac_alive + c3_mac_alive
		users_connected = c1_users_connected + c2_users_connected + c3_users_connected

		data = [ 
			{ series: "macs", tags: { cluster: "all" }, values: { mac_alive: mac_alive, users_connected: users_connected } },
			{ series: "macs", tags: { cluster: "c1" }, values: { mac_alive: c1_mac_alive, users_connected: c1_users_connected } },
			{ series: "macs", tags: { cluster: "c2" }, values: { mac_alive: c2_mac_alive, users_connected: c2_users_connected } },
			{ series: "macs", tags: { cluster: "c3" }, values: { mac_alive: c3_mac_alive, users_connected: c3_users_connected } },
		]

		client = InfluxDB::Rails.client
		client.write_points(data)
	end

end
