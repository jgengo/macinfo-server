class Location < ApplicationRecord
  belongs_to :client

  before_create :check_create

  def check_create 
    return if self.user == "exam"
    
    active_macs_locs = Location.where(client_id: self.client_id, end_at: nil)
    active_user_locs = Location.where(user: self.user, end_at: nil)

    if active_macs_locs.count > 0
        SlackIt.new.report("`#{self.user}` is logging in `#{self.client.hostname}` which already has active sessions for `#{active_macs_locs.pluck(:user).join("`, `")}`.").deliver
        active_macs_locs.update_all(end_at: Time.zone.now)
    end

    if active_user_locs.count > 0 
        SlackIt.new.report("`#{self.user}` is logging in `#{self.client.hostname}` but they already has active locations on `#{active_user_locs.joins(:client).pluck(:hostname).join("`, `")}`.").deliver
    end
  end

end
