class ProfileDocument < ActiveRecord::Base

	mount_uploader :document, ProfileDocumentUploader

	belongs_to :profile

end
