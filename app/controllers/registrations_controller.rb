class RegistrationsController < Devise::RegistrationsController

	def create
		@user = User.build(user_params)
		@fb_share_token = params[:fb_share_token]

		if @fb_share_token.present?
			@inviter = User.find_by_fb_share_token(@fb_share_token)

			if @inviter.present?
				@user.is_fb_invited = true
				@user.reward_credit = 5
				@user.invited_by_id = @inviter.id
				@inviter.reward_credit += 5
			end

		end
		if @user.sign_up
			@inviter.save if @inviter.present?

			#UserMailer.welcome_message(@user).deliver_now
			# sending email as backgound job using sidekiq + redis
			# UserMailer.delay_for(10.minutes).welcome_message(@user)
			
		#	UserMailer.welcome_message(@user).deliver_now

			flash[:success] = "Signed up successfully."
			if session["is_become_merchant"]
				sign_in :user, @user
				redirect_to become_merchant_path
			else
				sign_in_and_redirect(:user, @user)
			end
			
			mixpanel.track(@user.email, 'New User Signup', { campaign: 'New User Signup' })
		else
			if @inviter.present?
				return redirect_to "/users/fbshare_accept?token=#{@fb_share_token}"
			else
				render 'registrations/new'
			end
		end

	end

	def new
		super
	end

	private

	def user_params
		params.require(:user).permit(:first_name,:last_name,:email,:password,:password_confirmation)
		
	end
end