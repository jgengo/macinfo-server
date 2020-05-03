class Sync < ApplicationRecord

	def self.push_to_influxdb

		c1_mac_alive = Sync.where('hostname like ? and created_at > ?', "c1%", Time.zone.now - 10.minutes).count
		c2_mac_alive = Sync.where('hostname like ? and created_at > ?', "c2%", Time.zone.now - 10.minutes).count
		c3_mac_alive = Sync.where('hostname like ? and created_at > ?', "c3%", Time.zone.now - 10.minutes).count

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
