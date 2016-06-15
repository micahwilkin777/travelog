class Variant < ActiveRecord::Base
	belongs_to :product

	# monetize :price_cents
	attr_accessor :price_with_currency

	def set_price_with_discount
		discount = 1 - self.product.discount.to_f / 100
		self.price_with_currency = (discount * self.price_with_currency).round(2)
	end
end
