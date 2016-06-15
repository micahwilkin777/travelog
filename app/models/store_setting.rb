class StoreSetting < ActiveRecord::Base
	belongs_to :user
	has_one :store_image, dependent: :destroy
	has_one :account_document

	validates :user_id, :presence => true
	validates :store_username, :presence => true, :uniqueness => true
	validates :store_name, :presence => true

	after_create :init

	def init
		self.generate_uuid
	end

	def generate_uuid
		uuid = 'a' + SecureRandom.hex(25)
		store_setting = StoreSetting.find_by_uuid(uuid)
		while store_setting.present?
			uuid = 'a' + SecureRandom.hex(25)
			store_setting = StoreSetting.find_by_uuid(uuid)
		end
		self.uuid = uuid
		self.save
	end
end
