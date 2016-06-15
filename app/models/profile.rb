class Profile < ActiveRecord::Base
	belongs_to :user
	has_one :user_avatar
	has_many :profile_documents

	enum gender: {
		male: 1,
		female: 2
	}
	
	def full_name
		ret = ''
		ret += self.first_name if self.first_name.present?
		ret += ' ' + self.last_name if self.last_name.present?
	end
end
