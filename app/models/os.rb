class Os < ApplicationRecord
	has_many :clients

	after_destroy { |os| Client.where(os_id: os.id).update_all(os_id: nil) }
	
end
