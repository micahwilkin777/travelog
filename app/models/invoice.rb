class Invoice < ActiveRecord::Base

	belongs_to :product
	belongs_to :coupon
	
	serialize :variants, Array

	has_one :contact_detail

	enum status: {
		pending: 0,
		paid: 1,
		fullfilled: 2,
		cancelled: 3,
		completed: 4
	}

	
	belongs_to :user
	has_many :comments

	attr_accessor :price_with_currency
	attr_accessor :current_currency
	attr_accessor :currency_rate

	attr_accessor :reward_credit_with_currency

	attr_accessor :real_total
	attr_accessor :real_total_with_currency

	attr_accessor :total_billed

	
	def get_merchant_status
		status = 'Pending'
		if self.paid?
			status = "Paid"
		elsif self.fullfilled?
			status = "Fullfilled"
		elsif self.cancelled?
			status = "Cancelled"
		end
		status
	end

	def get_merchant_available_status_list
		status_list = []
		if self.paid?
			status_list.push('fullfilled')
			status_list.push('cancelled')
		else
			status_list.push(self.status)
		end
		status_list
	end

	def get_guest_available_status_list
		status_list = []
		if self.fullfilled?
			status_list.push('completed')
		else
			status_list.push(self.status)
		end
		status_list
	end


	def clean_variants
		invoice_variants = self.variants.clone
		invoice_variants = [] if invoice_variants.blank?
		invoice_variants.delete_if{|sa| sa.stringify_keys['count'].to_i == 0 }
		self.variants = invoice_variants

		# set the total price cents if got variants
		if self.variants.count > 0
			total_price_cents = 0
			self.variants.each do |variant|
				total_price_cents += variant["count"].to_i * variant["price_cents"].to_i
			end
			self.amount_cents = total_price_cents
		else
			self.amount_cents = self.product.price_cents
		end
	end

	def set_product_attributes
		if self.product.product_attachments.present? && self.product.product_attachments.count
  		self.product.product_overview_url = self.product.product_attachments[0].attachment.medium.url
  	end
  	self.product.user_avatar_url = self.product.user.get_avatar_url
	end

	def set_total_billed
		product_discount = self.product_discount.to_f / 100
		total_billed = self.billed
		if total_billed == 0.0
			total_billed = self.amount_cents.to_f / 100
			total_billed -= self.reward_credit if self.is_reward_credit
			total_billed -= self.coupon_amounts
		end
		self.total_billed = total_billed
	end

end
