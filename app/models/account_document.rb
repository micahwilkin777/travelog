class AccountDocument < ActiveRecord::Base

	mount_uploader :ic_passport, ICPassportDocumentUploader
	mount_uploader :bank, BankDocumentUploader
	mount_uploader :business, BusinessDocumentUploader
	belongs_to :store_setting

	validates :ic_passport, :presence => true
	validates :bank, :presence => true
	validates :business, :presence => true
end
