class PlacesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:search_place]

	def search_place
		@is_search = true
		countries = Product.select(:country).distinct.where("country is not null and country <> ''").pluck(:country)
		cities = Product.select(:city).distinct.where("city is not null and city <> ''").pluck(:city)
		gon.search_location_list = countries + cities


		@products = Product.public_active

		@slug = params[:slug]
		@city = params[:slug]
		unless @slug == 'all'
			@city = '' if @city.blank?
			@city = @city.gsub("-", " ")

			if @city.present?
				@products = @products.where("lower(city) LIKE ? or lower(country) like ?", "%#{@city.downcase}%", "%#{@city.downcase}%")
				@city_obj = City.where("lower(name) LIKE ?", "%#{@city.downcase}%").first
			end
		end
		
		@product_categories = ProductCategory.all
		category_names = @product_categories.select(:name).pluck(:name).map(&:downcase)
		if params[:search_free_text].present?
			# str_query += " and (lower(name) LIKE %#{params[:search_free_text].downcase}%)"
			if category_names.include? params[:search_free_text].downcase
				product_category = ProductCategory.where("lower(name) = ?", "#{params[:search_free_text].downcase}").first
				@products = @products.where(:product_category_id => product_category.id)
				@product_categories.each do |category|
					params["category_#{category.id}"] = "0"
				end
				params["category_#{product_category.id}"] = "1"
			else
				#@products = @products.where("lower(description) LIKE ? && name LIKE ?", "%#{params[:search_free_text].downcase}%", params[:search_free_text])
				@products = @products.where(
				  %w( name description highlight ).map { |column_name| 
				    "lower(#{column_name}) LIKE :query" 
				  }.join(' OR '),
				  query: "%#{params[:search_free_text].downcase}%")
				@search_free_text = params[:search_free_text]
			end
		end
		
		@categories = {}
		str_query = 'product_category_id = -1'
		temp_index = 0
		ProductCategory.order('id').each do |category|
			if params["category_#{category.id}"] == "on"
				@categories["category_#{category.id}"] = "1"
			else
				@categories["category_#{category.id}"] = params["category_#{category.id}"]
			end
			if @categories["category_#{category.id}"].present? && @categories["category_#{category.id}"].to_i
				str_query += " or product_category_id = #{category.id}"
			end
		end
		
		@products = @products.where(str_query)

		# set price range
		current_rate = session["currency-convert-#{session[:currency]}"].to_f
		gon.min_price = 0
		gon.max_price = current_rate * 1000

		# filter by price
		set_product_currency_attributes(@products)


		if params[:start_price].present?
			start_price = params[:start_price].to_f
			end_price = params[:end_price].to_f
			gon.start_price = start_price
			gon.end_price = end_price
			@products = @products.select{ |sa| sa.price_with_currency >= start_price && sa.price_with_currency <= end_price }

		end

		@total_count = @products.count
		if @products.class == Array
			@products = Kaminari.paginate_array(@products).page(params[:page]).per(8)
		else
			@products = @products.page(params[:page]).per(8)
		end
		
		params_clone = params.clone
		params_clone.delete("controller")
		params_clone.delete("action")

		# gon.current_location = "/products/result?#{params.to_query}"
		gon.current_location = "/place/#{@slug}?#{params_clone.to_query}"

		@products.each do |product|
			product.set_extra_attributes
		end

		set_product_currency_attributes(@products)

		@products.each do |product|
			product.set_review
		end
		
		@current_currency = get_all_currency_symbols[session[:currency]]


		render :layout => 'product_result'
	end

end