class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :invitable, :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
	attr_accessor :first_name, :last_name
	
	has_many :products
	has_one :profile
	has_one :store_setting
	after_create :send_welcome_message
	enum status: {
		normal: 0,
		merchant: 1
	}

	enum merchant_status: {
		pending: 0,
		verified: 1
	}

	has_many :product_reviews

	attr_accessor :avatar_url
	cattr_accessor :current_user

	after_create :update_access_token!

	def update_access_token!
    self.access_token = generate_access_token
    self.email = self.email.downcase
    save
  end

  def generate_access_token
    loop do
      token = "#{self.id}:#{Devise.friendly_token}"
      break token unless User.where(access_token: token).first
    end
  end
	
	def self.from_omniauth(auth)

		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			
			auth.info.image = auth.info.image+"?type=large"
			logger.info "status=facebook image type Auth #{auth.info.image}"
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]

			user.build_profile(first_name:auth.info.first_name,last_name:auth.info.last_name,avatar:auth.info.image)
		#user.name = auth.info.name   # assuming the user model has a name
		#user.image = auth.info.image # assuming the user model has an image
		end
	end

	def full_name
		full_name = self.profile.full_name if self.profile
		full_name
	end

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
				user.email = data["email"] if user.email.blank?
			end
		end
	end

	def is_merchant?
		false
	end

	def self.build(opts = {})
		
		u = User.new(opts.except(:first_name,:last_name,:id))
		u.setup(opts)
		u
	end

	def setup(opts)
		logger.info "status=Check opts value opts=#{opts[:first_name]}"
		self.email = opts[:email]
		self.valid?
		self.set_profile(Profile.new(first_name:opts[:first_name].capitalize, last_name:opts[:last_name].capitalize))
		self
	end

	def set_profile(profile)
		self.profile = profile
	end


	def get_avatar_url
		ret = ''
		if self.profile.present? && self.profile.user_avatar.present?
			ret = self.profile.user_avatar.avatar.thumb.url
		end
		if ret.blank? && self.provider == 'facebook'
			ret = self.profile.avatar
		end
		ret = "#{CUSTOM_CONFIG[:root_url]}assets/default-avatar.png" if ret.blank?
		ret
	end

	def get_store_thumb_url
		ret = ''
		if self.store_setting.present? && self.store_setting.store_image.present?
			ret = self.store_setting.store_image.store_img.thumb.url
		end
		ret
	end

	def is_buyed_product?(product)
		ret = false
		invoice = Invoice.where(:product_id => product.id, :user_id => self.id).where.not(:payer_id => nil).first
		ret = true if invoice.present?
		ret
	end

	def sign_up
		save
	end


	def set_fb_share_token
		self.fb_share_token = generate_fb_share_token
		save
	end


	private

		def send_welcome_message

			# sending email as backgound job using sidekiq + redis
			# UserMailer.delay_for(10.minutes).welcome_message(self)

			UserMailer.welcome_message(self).deliver_now
		end

		def generate_fb_share_token
			loop do
				token = "#{Devise.friendly_token}"
				break token unless User.where(fb_share_token: token).first
			end
		end

end
