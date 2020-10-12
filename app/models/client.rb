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

    after_commit :create_or_terminate_location, if: -> { self.saved_change_to_active_user? }

    def uptime_to_date
        Time.zone.now - self.uptime
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
    end

    def create_location
        active_user_locs = Location.where(user: self.active_user, end_at: nil)
        active_macs_locs = self.locations.where(end_at: nil)

        puts "===\nactive_user_locs: #{active_user_locs}\nactive_macs_locs: #{active_macs_locs}"

        if active_macs_locs.count > 0
            SlackIt.new.report("create_location for #{self.active_user} @ #{self.hostname} already has active locations for: #{active_macs_locs.pluck(:user).join(", ")}").deliver
            active_macs_locs.update_all(end_at: Time.zone.now)
        end

        if active_user_locs.count > 0 
            SlackIt.new.report("create_location for #{self.active_user}, but they already has active locations here: #{active_user_locs.joins(:client).pluck(:hostname).join(", ")}").deliver
        end

        self.locations.create!(user: self.active_user, begin_at: Time.zone.now)
    end

    def terminate_location
        active_macs_locs = self.locations.where(end_at: nil)

        if active_macs_locs.count > 1
            SlackIt.new.report("terminate_location for #{self.active_user} @ #{self.hostname} has more than one active location for (#{active_macs_locs.pluck(:user).join(", ")})").deliver
        end
        active_macs_locs.update_all(end_at: Time.zone.now)
    end

    def create_or_terminate_location
        if self.active_user != ""
            create_location
        else
            terminate_location
        end

        call_cluster_map if Rails.env.production?
    end
end
