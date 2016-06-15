class Product < ActiveRecord::Base
	
	extend FriendlyId
  friendly_id :name, use: :slugged
  
	belongs_to :user
	belongs_to :product_category
	belongs_to :location
	has_many :product_attachments, dependent: :destroy
	accepts_nested_attributes_for :product_attachments, allow_destroy: true
	has_many :variants, dependent: :destroy
	accepts_nested_attributes_for :variants, reject_if: proc { |attributes| attributes['name'].blank? }

	after_create :init

	has_many :product_reviews

	# scope :active, -> {where(:step => 5, :status => 1)}

	scope :active, -> {where(:step => 5, :status => 1).joins(:user).where('users.merchant_status = 1')}
	scope :random_active, -> {where(:step => 5, :status => 1).order('random()').joins(:user).where('users.merchant_status = 1')}

	# monetize :price_cents, :with_model_currency => :currency

	enum payment_type: {
		visa: 0,
		master: 1,
		american_express: 2,
		paypal: 3
	}

	enum step: {
		basic: 0,
		description: 1,
		location: 2,
		photo: 3,
		price: 4,
		complete: 5
	}

	enum status: {
		disable: 0,
		enable: 1
	}

	enum verification: {
		pending: 0,
		accepted: 1,
		rejected: 2
	}

	attr_accessor :product_overview_url
	attr_accessor :user_avatar_url

	attr_accessor :store_logo_url

	attr_accessor :price_with_currency
	attr_accessor :current_currency
	attr_accessor :currency_rate

	attr_accessor :review_mark
	attr_accessor :product_discount

	validates :name, :presence => true
	validates :product_category_id, :presence => true
	# validates :description, :presence => true
	# validates :highlight, :presence => true
	# validates :payment_type, :presence => true

	# exteneded scope for search the unverified merchant products
	def self.public_active
		# where(:step => 5, :status => 1).joins(:user).where('users.merchant_status = 1')
		product_arel_table = Product.arel_table
		user_arel_table = User.arel_table
		# scope = where(:step => 5, :status => 1).joins(:user).where('users.merchant_status = 1')
		# scope = where(product_arel_table[:step].eq(5).product_arel_table[:status].eq(1).user_arel_table[:merchant_status].eq(1))

		scope = where(:step => 5, :status => 1).joins(:user)

		scope = 
			scope.where(
				user_arel_table[:merchant_status].eq(1)
				.or(
					user_arel_table[:merchant_status].eq(0)
					.and(product_arel_table[:verification].eq(1))
				)
			)
		scope
	end

	def self.city_products(city, product_id, count)
		scope = where("lower(city) LIKE ?", "%#{city.downcase}%")
		scope = scope.where.not(:id => product_id)
		scope = scope.order('random()').limit(count)
		scope
	end
	

	def init
		self.currency = 'MYR'
	end

	def full_address
		full_address = "#{self.city}, #{self.country}"
		full_address = "#{self.address}, #{full_address}" if self.address.present?
		full_address
	end

	def set_review
		product_reviews = self.product_reviews
		total_review_count = product_reviews.count
		total_review = 0
		if total_review_count > 0 
			product_reviews.each do |product_review|
				total_review += product_review.rating_stars
			end
			self.review_mark = (total_review / total_review_count).round
		else
			self.review_mark = 0
		end
	end

	def set_price_with_currency(rate)
		self.price_with_currency = (self.price_cents * rate / 100).round(2)
	end

	def update_friendly_url
		self.slug = nil
		self.save
	end

	def set_extra_attributes
		if self.product_attachments.present? && self.product_attachments.count > 0
      self.product_overview_url = self.product_attachments[0].attachment.medium.url
    end
    self.user_avatar_url = self.user.get_avatar_url

    store_setting = self.user.store_setting
    if store_setting.present? && store_setting.store_image.present?
      self.store_logo_url = self.user.store_setting.store_image.store_img.small
    else
      self.store_logo_url = '/assets/default-avatar.png'
    end

    self.set_review
    self.set_product_price_with_discount
	end

	def set_product_price_with_discount
		discount = 1 - self.discount.to_f / 100
		self.product_discount = discount
	end

end
