class ProductAttachment < ActiveRecord::Base

	mount_uploader :attachment, AttachmentUploader
	belongs_to :product
end
