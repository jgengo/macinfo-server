class Sync < ApplicationRecord

	def self.push_to_influxdb
		mac_alive = Sync.where('created_at > ?', Time.zone.now - 10.minutes).count
		users_connected = Client.where.not(active_user: "").count

		data = [ 
			{ series: "macs", tags: { cluster: "all" }, values: { mac_alive: mac_alive, users_connected: users_connected } }
		]

		client = InfluxDB::Rails.client

		client.write_points(data)
	end

end
