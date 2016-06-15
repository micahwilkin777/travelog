require 'money/bank/google_currency'


class ProductsController < ApplicationController

	before_action :set_product, only: [:show, :edit, :update, :destroy, :write_comment, :remove_comment, :set_status]
	before_action :set_product_widget, only: [:edit_basic, :edit_description, :edit_location, :edit_photo, :edit_price]
	skip_before_action :authenticate_user!, only: [:result, :show]

	def layout_by_resource
		"product"
	end

	def index
		if current_user.status == 'merchant'
			# if current_user.merchant_status == 'verified'
				
			# else
			# 	redirect_to verify_document_path
			# end

			product_arel_table = Product.arel_table

			@products = current_user.products

			if current_user.merchant_status == 'verified'
				@listed_products = @products.where(:step => 5, :status => 1).includes(:product_attachments).includes(:product_reviews).order("created_at desc")

				@unlisted_products = @products.where(
				  product_arel_table[:step].not_eq(5).
				  or(product_arel_table[:status].not_eq(1))
				).includes(:product_attachments).includes(:product_reviews).order("created_at desc")

			else
				# for the non-verified user
				@listed_products = @products.where(:step => 5, :status => 1, :verification => 1).includes(:product_attachments).includes(:product_reviews).order("created_at desc")

				@unlisted_products = @products.where(product_arel_table[:step].not_eq(5).or(product_arel_table[:status].not_eq(1)).or(product_arel_table[:verification].not_eq(1))
				).includes(:product_attachments).includes(:product_reviews).order("created_at desc")				
			end

			# @unlisted_products = @products.where.not(:step => 5).includes(:product_attachments).includes(:product_reviews).order("created_at desc")


			unless current_user.merchant_status == 'verified'
				@is_verify_need = true
			end

			@unlisted_products.each do |product|
				product.set_extra_attributes
			end

			@listed_products.each do |product|
				product.set_extra_attributes
			end
		else
			redirect_to root_path
		end
	end

	def show
		@user = @product.user
		# @other_products = Product.public_active.order('random()').limit(4).includes(:product_attachments).includes(:product_reviews)
		@same_city_products = Product.city_products(@product.city, @product.id, 4)

		@same_city_products.each do |product|
			product.set_extra_attributes
		end
		set_product_currency_attributes(@same_city_products)

		same_city_product_count = @same_city_products.count

		if same_city_product_count < 4
			@kl_products = Product.city_products('Kuala Lumpur', @product.id, 4 - same_city_product_count)
			@kl_products.each do |product|
				product.set_extra_attributes
			end
			set_product_currency_attributes(@kl_products)
		end
		
		@product_cover_image_url = @product.product_attachments.order('id')[0].attachment.url if @product.product_attachments.count > 0
		gon.product_cover_image_url = @product.product_attachments.order('id')[0].attachment.large.url if @product.product_attachments.count > 0
		@is_variants = true if @product.variants.count > 0

		if @product.currency != session[:currency]
			rate = session["currency-convert-#{session[:currency]}"].to_f / session["currency-convert-#{@product.currency}"].to_f
		else
			rate = 1.0
		end

		@product.price_with_currency = (@product.price_cents * rate / 100).round(2)
		@product.current_currency = session[:currency]
		@product.variants.each do |variant|
			variant.price_with_currency = (variant.price_cents * rate / 100).round(2)
		end
		
		gon.variants = @product.variants if @is_variants

		
		@current_currency = get_all_currency_symbols[session[:currency]]

		# set params for product reivews
		if user_signed_in?
			@product_reviews = @product.product_reviews.where(:user_id => current_user.id)
			@product_reviews += @product.product_reviews.where.not(:user_id => current_user.id).order('user_id')  
		else
			@product_reviews = @product.product_reviews
		end
		
		@total_review_count = @product_reviews.count

		# set the review mark
		@product.set_review
		
		@product_reviews = Kaminari.paginate_array(@product_reviews).page(params[:page]).per(10)

		@product_reviews.each do |product_review|
			product_review.set_avatar_url
		end

		@original_url = request.original_url

		
		@product_discount = 1 - @product.discount.to_f / 100

		render :layout => "product_detail"
	end

	def write_comment
		message = params[:message]
		product_review = ProductReview.where(:user_id => current_user.id, :product_id => @product.id).first
		product_review = ProductReview.new({:user_id => current_user.id, :product_id => @product.id}) if product_review.blank?
		product_review.message = message
		product_review.rating_stars = params["rating-stars"].to_i
		if product_review.save
			product_name = @product.name
			# UserMailer.delay_for(10.minutes).write_review(current_user, @product, message)
			redirect_to product_path @product
		else
			redirect_to root_path
		end
	end

	def remove_comment
		product_review = ProductReview.find_by_id(params[:review_id])
		if product_review.present? && product_review.product_id == @product.id && product_review.user_id == current_user.id
			product_review.destroy
			render :json => {:status => 'success'}.to_json
		else
			render :json => {:status => 'fail'}.to_json
		end
	end

	def new
		# if current_user.status == 'merchant' && current_user.merchant_status == 'verified'
		if current_user.status == 'merchant'
			@product = Product.new
			@categories = ProductCategory.all
			@product_attachment = @product.product_attachments.build
			@product_attachments = ProductAttachment.all
			@show_section = 'basic'
			render :layout => 'product_new'
		else
			redirect_to root_path
		end
	end

	def create
		@product = Product.new(product_params)
		@product.user = current_user
		respond_to do |format|

			if params[:product].present?
				unless @product.save
					# format.html { render :new }
					
					format.html { redirect_to new_product_path }
					format.json { render json: @product_attachment.errors, status: :unprocessable_entity }
				end
			end
			
			param_variants = params[:variant]
			if param_variants.present?
				param_variants.delete_if{|sa| !sa.stringify_keys['name'].present? }
			else
				param_variants = []
			end
			
			if param_variants.count > 0
				base_price_cents = (param_variants[0][:price_cents].to_f * 100).to_i
				param_variants.each do |param_variant|
					if param_variant[:name].present?
						variant = Variant.new
						variant.name = param_variant[:name]
						variant.price_cents = (param_variant[:price_cents].to_f * 100).to_i
						variant.product = @product
						variant.min_count = param_variant[:min_count].to_i if param_variant[:min_count].present?
						variant.max_count = param_variant[:max_count].to_i if param_variant[:max_count].present?
						if variant.min_count.present? && variant.max_count.present? && variant.max_count < variant.min_count
							variant.max_count = variant.min_count
						end
						variant.save  
					end
				end
				@product.price_cents = base_price_cents
			end

			if params[:product_attachment].present?
				params[:product_attachment]['id'].each do |a|
					product_attachment = ProductAttachment.find(a)
					if product_attachment.present?
						product_attachment.product = @product
						product_attachment.save
					end
				end
			end
			

			step_param = params["step-param"]
			case step_param
			when "basic"
				if @product.step == 'basic'
					@product.step = 'description'
					@product.save
				end
				format.html { redirect_to edit_description_product_path @product, :flash => { :notice => "Added a new product successfully." } }
				format.json { render :show, status: :ok, location: @product_attachment }
			when "description"
				format.html { redirect_to edit_location_product_path @product }
				format.json { render :show, status: :ok, location: @product_attachment }
			when "location"
				format.html { redirect_to edit_photo_product_path @product }
				format.json { render :show, status: :ok, location: @product_attachment }
			when "photo"
				format.html { redirect_to edit_price_product_path @product }
				format.json { render :show, status: :ok, location: @product_attachment }
			else
				format.html { redirect_to products_path }
				format.json { render :show, status: :ok, location: @product_attachment }
			end
			
		end
	end

	def edit
		# @categories = ProductCategory.all
		# render :layout => 'product_new'
		case @product.step
		when 'basic'
			redirect_to edit_basic_product_path @product
		when 'description'
			redirect_to edit_description_product_path @product
		when 'location'
			redirect_to edit_location_product_path @product
		when 'photo'
			redirect_to edit_photo_product_path @product
		when 'price'
			redirect_to edit_price_product_path @product
		else
			redirect_to edit_basic_product_path @product
		end
		
	end

	def edit_basic
		@show_section = 'basic'
		render :layout => 'product_new', :template => 'products/edit'
	end

	def edit_description
		@show_section = 'description'
		render :layout => 'product_new', :template => 'products/edit'
	end

	def edit_location
		@show_section = 'location'
		render :layout => 'product_new', :template => 'products/edit'
	end

	def edit_photo
		@show_section = 'photo'
		render :layout => 'product_new', :template => 'products/edit'
	end

	def edit_price
		gon.product_status = @product.status
		@show_section = 'price'
		render :layout => 'product_new', :template => 'products/edit'
	end

	def set_status
		@product.status = params[:status]
		if @product.save
			render :json => @product, status: 200
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /products/1
	# PATCH/PUT /products/1.json
	def update
		respond_to do |format|
			if params[:product].present?
				unless @product.update_attributes(product_params)
					format.html { return render :edit }
					format.json { return render json: @product_attachment.errors, status: :unprocessable_entity }
				end
			end

			# update frinedly url
			@product.update_friendly_url
			
			param_variants = params[:variant]
			if param_variants.present?
				param_variants.delete_if{|sa| !sa.stringify_keys['name'].present? }
				@product.variants.delete_all
			else
				param_variants = []
			end
			
			if param_variants.count > 0
				base_price_cents = (param_variants[0][:price_cents].to_f * 100).to_i
				param_variants.each do |param_variant|
					if param_variant[:name].present?
						variant = Variant.new
						variant.name = param_variant[:name]
						variant.price_cents = (param_variant[:price_cents].to_f * 100).to_i
						variant.product = @product
						variant.min_count = param_variant[:min_count].to_i if param_variant[:min_count].present?
						variant.max_count = param_variant[:max_count].to_i if param_variant[:max_count].present?
						if variant.min_count.present? && variant.max_count.present? && variant.max_count < variant.min_count
							variant.max_count = variant.min_count
						end
						variant.save
					end
				end
				@product.price_cents = base_price_cents
				@product.save
			end
			if params[:product_attachment].present?
				params[:product_attachment]['id'].each do |a|
					product_attachment = ProductAttachment.find(a)
					if product_attachment.present?
						product_attachment.product = @product
						product_attachment.save
					end
				end
			end

			step_param = params["step-param"]
			case step_param
			when "basic"
				if @product.step == 'basic'
					@product.step = 'description'
					@product.save
				end
				format.html { redirect_to edit_description_product_path @product, :flash => { :notice => "Updated the product successfully." } }
				format.json { render :show, status: :ok, location: @product_attachment }
			when "description"
				if @product.step == 'description'
					@product.step = 'location'
					@product.save
				end
				format.html { redirect_to edit_location_product_path @product, :flash => { :notice => "Updated the product successfully." } }
				format.json { render :show, status: :ok, location: @product_attachment }
			when "location"
				if @product.step == 'location'
					@product.step = 'photo'
					@product.save
				end
				format.html { redirect_to edit_photo_product_path @product, :flash => { :notice => "Updated the product successfully." } }
				format.json { render :show, status: :ok, location: @product_attachment }
			when "photo"
				if @product.step == 'photo'
					@product.step = 'price'
					@product.save
				end
				format.html { redirect_to edit_price_product_path @product, :flash => { :notice => "Updated the product successfully." } }
				format.json { render :show, status: :ok, location: @product_attachment }
			when "price"
				if @product.step == 'price'
					@product.step = 'complete'
					@product.save
				end
				format.html { redirect_to products_path }
				format.json { render :show, status: :ok, location: @product_attachment }
			else
				format.html { redirect_to products_path }
				format.json { render :show, status: :ok, location: @product_attachment }
			end
		end
	end

	# DELETE /products/1
	# DELETE /products/1.json
	def destroy
		@product.destroy
		respond_to do |format|
			format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		def set_product
			@product = Product.friendly.find(params[:id])
		end

		def set_product_widget
			set_product
			if @product.user != current_user
				redirect_to root_path
			end
			flash.clear
			
			if params[:flash].present?
				params[:flash].each do |k, v|
					flash[k] = v
				end
			end
			@categories = ProductCategory.all
		end

		def product_params
			op = params.require(:product).permit(:name, :product_category_id, :payment_type, :location_id, 
				:country, :address, :apt, :city, :state, :zip, :price_cents, :currency, :description, 
				:highlight, :refundable, :refund_day, :refund_percent, :discount, :variants_attributes => [:id, :name, :price_cents])
			op[:price_cents] = (op[:price_cents].to_f * 100).to_i if op[:price_cents].present?
			
			op
		end

end
