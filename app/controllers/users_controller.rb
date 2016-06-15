class UsersController < ApplicationController
	skip_before_action :authenticate_user!, only:[:become_merchant, :invite, :fbshare, :fbshare_accept, :about, :blog, :career, :contact, :press, :terms, :policy, :help, :merchant_landing]
	before_action :set_user_profile, only: [:profile, :profile_avatar, :profile_accounts, :profile_document, :profile_security]
	before_action :set_accounts, only: [:accounts, :accounts_photo, :account_document, :getting_paid]

	def layout_by_resource
    "product"
  end

  # click become merchant 
  def merchant_landing
  	# unless user_signed_in?
  	# 	session["is_become_merchant"] = true
  	# 	redirect_to new_user_registration_path
  	# end
  end 

	def become_merchant

		if user_signed_in?
			if current_user.status != 'merchant'
				
				@store_setting = StoreSetting.new({:user_id => current_user.id})
				gon.store_usernames = StoreSetting.select(:store_username).pluck(:store_username)
			else
				redirect_to root_path
			end	
		else
			session["is_become_merchant"] = true
			redirect_to new_user_registration_path
		end
	end

	def profile
		if request.get?
			@profile = Profile.new({:user_id => current_user.id}) if @profile.blank?
			if @profile.birthday.present?
				@year = @profile.birthday.year
				@month = @profile.birthday.month
				@day = @profile.birthday.day
			end
		else
			birthday = nil
			begin
				birthday = DateTime.new(params["profile-year"].to_i, params["profile-month"].to_i, params["profile-day"].to_i)
			rescue Exception => e
				
			end
			
			if @profile.blank?
				@profile = Profile.new(profile_params)
				@profile.user_id = current_user.id
	
				flash[:success] = "Created the profile successfully."
			else
				@profile.update(profile_params)
				flash[:success] = "Updated the profile successfully."
			end
			@profile.birthday = birthday
			@profile.save
			redirect_to root_path

		end
	end

	def profile_avatar
		if request.get?
			@profile = Profile.new({:user_id => current_user.id}) if @profile.blank?
		else
			if params[:user_avatar].present? && params[:user_avatar][:id].present?
				user_avatar = UserAvatar.find(params[:user_avatar][:id])
				if @profile.save
					user_avatar.profile = @profile
					user_avatar.save
					redirect_to root_path
				end
			end
		end
	end

	def profile_security
		if request.get?
			@profile = Profile.new({:user_id => current_user.id}) if @profile.blank?
		else
			
			@form_type = params[:form_type]
			old_password = params[:user][:old_password]
			new_password = params[:user][:new_password]
			new_email = params[:user][:email]
			if @form_type == 'password'
				if not current_user.valid_password?(old_password)
					current_user.errors.add(:password, "is not correct.")
					@error_type = 'password'
					return render 'profile_security'
				end

				current_user.password = new_password
				if current_user.save
					flash[:success] = 'Successfully updated the password.'
					redirect_to root_path
				end
			elsif @form_type == 'email'
				current_user.email = new_email
				if current_user.save
					flash[:success] = 'Successfully updated the email.'
					redirect_to root_path
				end
			end
			
		end
	end

	def profile_document
		if request.get?
			@profile = Profile.new({:user_id => current_user.id}) if @profile.blank?
		else
			if params[:document_id].present? && params[:document_id].count > 0
				params[:document_id].each do |document_id|
					profile_document = ProfileDocument.find(document_id)
					if profile_document.present?
						profile_document.profile = @profile
						profile_document.save
					end
				end
			end

			redirect_to root_path
		end
	end

	def account_document
		if current_user.status != 'merchant'
			return redirect_to root_path
		end
		if request.get?
			if @store_setting.blank?
				redirect_to root_path
			end
			@account_document = @store_setting.account_document
			@account_document = AccountDocument.new({:store_setting_id => current_user.id}) if @account_document.blank?
		else
			# if params[:document_id].present? && params[:document_id].count > 0
			# 	params[:document_id].each do |document_id|
			# 		profile_document = ProfileDocument.find(document_id)
			# 		if profile_document.present?
			# 			profile_document.profile = @profile
			# 			profile_document.save
			# 		end
			# 	end
			# end

			return redirect_to root_path
		end
	end

	def getting_paid
		if current_user.status != 'merchant'
			return redirect_to root_path
		end
		if request.get?
			@store_setting = StoreSetting.new({:user_id => current_user.id}) if @store_setting.blank?
		else
			if @store_setting.update(store_setting_params)
				flash[:notice] = "Updated the store setting successfully."
				redirect_to root_path
			end
		end
	end

	def accounts
		if current_user.status != 'merchant'
			redirect_to root_path
		end
		if request.get?
			@store_setting = StoreSetting.new({:user_id => current_user.id}) if @store_setting.blank?
		else
			if @store_setting.update(store_setting_params)
				flash[:notice] = "Updated the store setting successfully."
				redirect_to root_path
			end
		end
	end

	def accounts_photo
		if current_user.status != 'merchant'
			redirect_to root_path
		end
		if request.get?
		else
			if params[:store_image].present? && params[:store_image][:id].present?
				store_image = StoreImage.find(params[:store_image][:id])
				if store_image.present?
					store_image.store_setting = @store_setting
					store_image.save
					redirect_to root_path
				end
			end	
		end
	end

	# complete become merchant
	def complete_merchant
		if user_signed_in?
			@store_setting = StoreSetting.new(store_setting_params)
			@store_setting.user_id = current_user.id
			if params[:store_image].present? && params[:store_image][:id].present?
				store_image = StoreImage.find(params[:store_image][:id])
				if store_image.present?
					if @store_setting.save
						store_image.store_setting = @store_setting
						store_image.save
						# change status of the current user
						current_user.status = 'merchant'
						UserMailer.welcome_merchant(current_user,@store_setting).deliver_now
						#UserMailer.notif_welcome_merchant(current_user,@store_setting).deliver_now
						#mixpanel.track(current_user.email, 'New Merchant Signup', { campaign: 'New Merchant Signup' })
						current_user.save

# <<<<<<< HEAD
# 						logger.info "{event=REGISTRATION_STORE_V2 status=successful store=#{current_user.full_name}}"
# 						UserMailer.welcome_merchant(current_user,@store_setting).deliver_later
# 						flash[:notice] = "Merchant signup is successfully. Please check your email"
# 						redirect_to root_path
# =======

						flash[:notice] = "Become merchant successfully. Please verify for your account."

						redirect_to products_path
						# redirect_to root_path
						# render :layout => 'product'
					end
				end
			else
				@store_setting.errors.add(:store_image, "can't be blank.")
				respond_to do |format|
	        format.html {render :become_merchant}
	        format.json {render json: { :errors => @store_setting.errors, :store_setting => @store_setting }, status: 422}
	      end
			end	
		end
	end

	def verify_document
		if user_signed_in? && current_user.status == 'merchant' && current_user.merchant_status == 'pending'

		else
			redirect_to root_path
		end
	end

	def complete_merchant1
	end

	# verify the store username for uniquness
	def verify_store_username
		store_setting = StoreSetting.where(:store_username => params[:store_username])
		if store_setting.blank?
			respond_to do |format|
				format.json { render json: {:result => true}}
			end
		else
			respond_to do |format|
				format.json { render json: {:result => false}}
			end
		end
	end

	# GET /resource/invitation/invite?invitation_token=abcdef 
	# for invitation by email: the page for invitee
  def invite
  	if current_user
  		return redirect_to root_path
  	end
    @invitation_token = params[:invitation_token]
    @user = User.find_by_id(params[:user_id])
    render :invite
  end

  # for fb share page for inviter
  def fbshare
  	@fb_share_token = params[:token]
  	@original_url = request.original_url

  	@user = User.find_by_fb_share_token(@fb_share_token)
  	if @user.blank?
  		return redirect_to root_path
  	end
  	render 'fbshare'
  end

  # fb invite page for invitee
  def fbshare_accept
  	@fb_share_token = params[:token]
  	if current_user
  		return redirect_to root_path
  	end
    @inviter = User.find_by_fb_share_token(@fb_share_token)
    if @inviter.blank?
  		return redirect_to root_path
  	end
  	@user = User.new
    render :template => 'users/fbshare_accept', :layout => 'users'
  end


  # dashboard page
  def dashboard

  end

  def about
  	@nav_obj = 'about'
  	render :layout => 'static'
  end

  def blog
  	@nav_obj = 'blog'
  	render :layout => 'static'
  end

  def career
  	@nav_obj = 'career'
  	render :layout => 'static'
  end

  def contact
  	@nav_obj = 'contact'
  	render :layout => 'static'
  end

  def press
  	@nav_obj = 'press'
  	render :layout => 'static'
  end

  def terms
  	@nav_obj = 'terms'
  	render :layout => 'static'
  end

  def policy
  	@nav_obj = 'policy'
  	render :layout => 'static'
  end

  def help
  	@nav_obj = 'help'
  	render :layout => 'static'
  end

	private
		def store_setting_params
			params.require(:store_setting).permit(:store_username, :store_name, :phone_number, :mobile_number, :website, :merchant_type, :know_us_text, :country, :city, :paypal_email, :currency)
		end

		def profile_params
			params.require(:profile).permit(:first_name, :last_name, :gender, :phone_number)
		end

		def set_user_profile
			@profile = current_user.profile
		end

		def set_accounts
			@store_setting = current_user.store_setting
		end
end
