namespace :travelog do
	task set_uuid_for_existing_store_setting: :environment do
		store_settings = StoreSetting.where(:uuid => nil)
		store_settings.each do |store_setting|
			store_setting.generate_uuid
		end
	end

	task create_access_token_for_existing_users: :environment do
		User.all.each do |user|
			user.update_access_token! if user.access_token.blank?
		end
	end
end