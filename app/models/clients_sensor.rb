class ClientsSensor < ApplicationRecord
  belongs_to :sensor
  belongs_to :client
end
