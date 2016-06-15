class HomeController < ApplicationController

	skip_before_action :authenticate_user!, only: [:index, :home_products]

	def index

		# @products = Product.random_active.limit(6).includes(:product_attachments).includes(:product_reviews)
		@products = Product.public_active.order('random()').limit(6).includes(:product_attachments).includes(:product_reviews)

		@products.each do |product|
			if product.currency != session[:currency]
				if session["currency-convert-#{product.currency}"].to_f == 0.0
					rate = 1.0	
				else
					rate = session["currency-convert-#{session[:currency]}"].to_f / session["currency-convert-#{product.currency}"].to_f
				end
	      
	    else
	      rate = 1.0
	    end

			product.price_with_currency = (product.price_cents * rate / 100).round(2)
			product.current_currency = session[:currency]
		end
		@product_attachments = ProductAttachment.all 
		#logger.info "status=Fetching Home Product image=#{@products.product_attachments.try(:first).attachment}" 

		@countries = Product.select(:country).distinct.where("country is not null and country <> ''").pluck(:country)
		@cities = Product.select(:city).distinct.where("city is not null and city <> ''").pluck(:city)
		
		# process for case insentive
		# @countries.each do |country|
		# 	country = country.split.map(&:capitalize).join(' ')
		# end

		@countries.map! {|country| country.split.map(&:capitalize).join(' ')}

		# @cities.each do |city|
		# 	city = city.split.map(&:capitalize).join(' ')
		# end

		@cities.map! {|city| city.split.map(&:capitalize).join(' ')}

		@countries = @countries.uniq
		@cities = @cities.uniq


		gon.search_location_list = @countries + @cities
		gon.search_interests = ProductCategory.select(:name).pluck(:name)
		@search_location_list = @countries + @cities
		# gon.home_products = @products

		# count per city
		@count_per_city = {}
		@cities.each do |city|
			@count_per_city[city] = Product.public_active.where("lower(city) LIKE ? or lower(country) like ?", "%#{city.downcase}%", "%#{city.downcase}%").count
		end

		@products.each do |product|
			product.set_extra_attributes
		end

	end

	def home_products
		city = params[:city]
		if city.downcase == 'all cities'
			@products = Product.public_active.order('random()').limit(6).includes(:product_attachments).includes(:product_reviews)
		else
			@products = Product.public_active.order('random()').where("lower(city) LIKE ? or lower(country) like ?", "%#{params[:city].downcase}%", "%#{params[:city].downcase}%").limit(6)
		end
		
		@products.each do |product|
			if product.currency != session[:currency]
	      rate = session["currency-convert-#{session[:currency]}"].to_f / session["currency-convert-#{product.currency}"].to_f
	    else
	      rate = 1.0
	    end

			product.price_with_currency = (product.price_cents * rate / 100).round(2)
			product.current_currency = session[:currency]
		end

		@products.each do |product|
			product.set_extra_attributes
		end
		render :layout => false
	end

	# def search
	# 	render :template => "products/result"
	# end

end
