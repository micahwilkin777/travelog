class CitiesController < ApplicationController

	before_action :set_city, only: [:show, :category]
	skip_before_action :authenticate_user!, only: [:index, :show]

	def layout_by_resource
		"product_detail"
	end

	def index
	end

	def show

		@products = Product.where("lower(city) LIKE ? ", "%#{@city.name.downcase}%").public_active.order('created_at desc').limit(3).includes(:product_attachments).includes(:product_reviews)
		@products.each do |product|
			product.set_extra_attributes
		end

		gon.city_cover_image_url = @city.bg_cover_img
	end

	def category
		@category_name = params[:category_name]
		@products = Product.joins(:product_category).where("lower(city) LIKE ? ", "%#{@city.name.downcase}%").public_active.where("lower(product_categories.name) = '#{@category_name.downcase}'").limit(3).includes(:product_attachments).includes(:product_reviews)

		@products.each do |product|
			product.set_extra_attributes
		end

		gon.city_cover_image_url = @city.bg_cover_img
	end

	private

		def set_city
			@city = City.friendly.find(params[:id])
		end
end