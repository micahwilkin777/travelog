module Api
	module V1
		class UsersController < Api::V1::BaseController
			skip_before_action :authenticate_user_from_token!, only: [:login, :signup]

			def login
				user = User.find_for_database_authentication(email: params[:email])
				return invalid_login_attempt unless user

				if user.valid_password?(params[:password])
					sign_in :user, user
					render json: user, serializer: Api::V1::SessionSerializer
				else
					invalid_login_attempt
				end
			end

			def profile
				render json: current_user.profile, serializer: Api::V1::ProfileSerializer
			end

			def signup
				user = User.build(signup_params)
				if user.save
					render json: user, serializer: Api::V1::SessionSerializer
				else
					render json: { error: 'user_signup_error', error_messages: user.errors.full_messages }, status: :unprocessable_entity
				end
			end

			private
				def invalid_login_attempt
					warden.custom_failure!
					render json: {error: 'sessions_controller.invalid_login_attempt'}, status: :unprocessable_entity
				end

				def signup_params
					params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
				end
		end
	end
end