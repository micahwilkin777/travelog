class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    #logger.info "status=facebook omniauth user#{@user.profile.avatar?type=large}"
    # @user_avatar = UserAvatar.new(profile_id: @user.profile.id, avatar:@user.profile.avatar)
    # @user_avatar.save
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      # binding.pry
      existing_user = User.find_by_email(@user.email)
      if existing_user.present?
        existing_user.provider = @user.provider
        existing_user.uid = @user.uid
        if existing_user.profile.present?
          existing_user.profile.gender = @user.profile.gender
          existing_user.profile.birthday = @user.profile.birthday
        end
        existing_user.profile = @user.profile

        if existing_user.save
          sign_in_and_redirect existing_user, :event => :authentication #this will throw if @user is not activated
          set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
          return
        end
      end
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end