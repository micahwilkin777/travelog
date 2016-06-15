class StoreImage < ActiveRecord::Base
	mount_uploader :store_img, StoreImageUploader
	belongs_to :store_setting
end
