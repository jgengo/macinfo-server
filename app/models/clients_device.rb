class ClientsDevice < ApplicationRecord
  belongs_to :device
  belongs_to :client
end
