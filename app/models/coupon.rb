class Coupon < ActiveRecord::Base

	
	attr_accessor :amounts_with_converted
	attr_accessor :currency_rate
	attr_accessor :current_currency

	attr_accessor :amounts_with_user_currency
	attr_accessor :amounts_with_product_currency
	
	# monetize :amount_cents, :with_model_currency => :currency
	
end
