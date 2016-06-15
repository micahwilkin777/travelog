class CouponsController < ApplicationController

	
	def get_coupon
		code = params[:code]
		product_currency = params[:product_currency]
		coupon = Coupon.find_by_code(code)
		
		if coupon.present?
			# rate for display currency
			if coupon.currency != session[:currency]
				rate = (session["currency-convert-#{session[:currency]}"].to_f / session["currency-convert-#{coupon.currency.upcase}"].to_f)
			else
				rate = 1.0
			end

			coupon.amounts_with_user_currency = (coupon.amount_cents * rate / 100).round(2)
			
			# rate for product currency
			if coupon.currency != product_currency
				rate = (session["currency-convert-#{product_currency}"].to_f / session["currency-convert-#{coupon.currency.upcase}"].to_f)
			else
				rate = 1.0
			end

			coupon.amounts_with_product_currency = (coupon.amount_cents * rate / 100).round(2)

			render json: coupon, serializer: Api::V1::CouponSerializer, status: 200
		else
			render json: coupon, status: :unprocessable_entity
		end
	end
	
end