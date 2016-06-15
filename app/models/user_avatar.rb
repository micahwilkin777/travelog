class UserAvatar < ActiveRecord::Base
	mount_uploader :avatar, AvatarUploader
	belongs_to :profile
end
