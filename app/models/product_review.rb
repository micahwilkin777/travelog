class ProductReview < ActiveRecord::Base
	belongs_to :user
	belongs_to :product

	attr_accessor :avatar_url

	def set_avatar_url
		avatar_url = ''
		avatar_url = self.user.get_avatar_url if self.user.present?
		self.avatar_url = avatar_url
	end
end
