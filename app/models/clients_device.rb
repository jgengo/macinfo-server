class ClientsDevice < ApplicationRecord
  belongs_to :device
  belongs_to :client

  def self.delete_old_entries
    ClientsDevice.where('created_at < ?', Time.zone.now - 15.days).destroy_all
  end
end
