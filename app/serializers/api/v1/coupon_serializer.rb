module Api
	module V1
		class CouponSerializer < ActiveModel::Serializer
			attributes :id, :code, :coupon_currency, :coupon_amounts, :amounts_with_user_currency, :amounts_with_product_currency

			def coupon_currency
				object.currency
			end

			def coupon_amounts
				(object.amount_cents.to_f / 100).round(2)
			end

			def amounts_with_user_currency
				object.amounts_with_user_currency
			end

			def amounts_with_product_currency
				object.amounts_with_product_currency
			end

		end
	end
end