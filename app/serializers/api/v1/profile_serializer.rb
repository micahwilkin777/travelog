module Api
	module V1
		class ProfileSerializer < ActiveModel::Serializer
			attributes :id, :first_name, :last_name, :birthday, :gender
		end
	end
end