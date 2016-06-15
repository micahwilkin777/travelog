module Api
	module V1
		class SessionSerializer < ActiveModel::Serializer
			attributes :id, :access_token, :status, :avatar_url
			# has_one :profile, :serializer => ProfileSerializer

			def avatar_url
				avatar_url = object.get_avatar_url if object.get_avatar_url.present?
				avatar_url
			end

		end
	end
end