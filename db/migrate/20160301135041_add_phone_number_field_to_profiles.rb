class AddPhoneNumberFieldToProfiles < ActiveRecord::Migration
  def change
  	add_column :profiles, :phone_number, :string
  end
end
