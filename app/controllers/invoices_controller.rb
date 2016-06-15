class InvoicesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:new]
	skip_before_action :redirect_to_checkout, only: [:new, :create]
	def layout_by_resource
		"product"
	end

	def index
		@invoices = Invoice.where.not(:payer_id => nil)
		current_time = DateTime.now.strftime('%F')
		@upcomming_invoices = Invoice.where.not(:payer_id => nil).where("booking_date > ?", current_time)
		@previous_invoices = Invoice.where.not(:payer_id => nil).where("booking_date <= ?", current_time)
	end

	def new
		
		@invoice = Invoice.new
		if user_signed_in?
			@contact_detail_params = {
				first_name: current_user.profile.first_name,
				last_name: current_user.profile.last_name,
				email: current_user.email,
				phone_number: current_user.profile.phone_number
			}
		end
		
		if request.post?
			
			@invoice.booking_date = params[:datepicker]
			@invoice.product_id = params["product-id"]
			@invoice.variants = params[:variant]
			if !user_signed_in?
				session[:pending_invoice] = @invoice
				return redirect_to new_user_session_path
			end

			set_extra_params_for_new

			@invoice_params = {}

		else
			@contact_detail_params = params[:contact_detail] if params[:contact_detail].present?
			if (session[:pending_invoice].present?) && (session[:pending_invoice].instance_of? Invoice)
				
				@invoice = session[:pending_invoice]
				set_extra_params_for_new

				@invoice_params = {}
				# session[:pending_invoice] = nil
				session[:is_require_load_pending_invoice] = true
			else
				@invoice.booking_date = params[:invoice][:booking_date]
				@invoice.product_id = params[:invoice][:product_id]
				@invoice.coupon_id = params[:invoice][:coupon_id]
				@invoice.coupon_amounts = params[:invoice][:coupon_amounts]
				@coupon_amounts_with_user_currency = params[:invoice][:coupon_amounts_with_user_currency]
				@invoice.variants = params[:variant]

				set_extra_params_for_new

				@invoice_params = params[:invoice]
				# @contact_detail_params = params[:contact_detail]
			end
		end

		set_invoice_currency_attributes(@invoice)

		gon.invoice = @invoice
		gon.real_total_with_currency = @invoice.real_total_with_currency
		gon.real_total = @invoice.real_total

		# if user_signed_in?
		# 	set_invoice_currency_attributes(@invoice)
		# else
		# 	session[:pending_invoice] = @invoice
		# 	redirect_to new_user_session_path
		# end

	end

	def create

		@invoice = Invoice.new(invoice_params)
		@invoice.user = current_user
		param_variants = params[:variant]
		param_variants = [] if param_variants.blank?
		param_variants.delete_if{|sa| sa.stringify_keys['count'].to_i == 0 }

		product = @invoice.product
		product_percent_rate = product.discount
		product_percent_rate = 1 - product_percent_rate.to_f / 100

		# binding.pry
		if product.discount != 0
			param_variants.each do |variant|
				variant[:discount] = 100 - product.discount
			end
		end
		@invoice.product_discount = product.discount

		if param_variants.count > 0
			@invoice.variants = param_variants 
		end


		paypal_options = {
			no_shipping: true, # if you want to disable shipping information
			allow_note: false, # if you want to disable notes
			pay_on_paypal: true # if you don't plan on showing your own confirmation step
		}
		request = Paypal::Express::Request.new(

			:username   => PAYPAL_CONFIG[:username],
			:password   => PAYPAL_CONFIG[:password],
			:signature  => PAYPAL_CONFIG[:signature]
		)
		payment_requests = []
		items = []

		billed_price = 0.0

		if @invoice.variants.present? && @invoice.variants.count > 0
			seller_id = SecureRandom.hex(5)
			puts seller_id  
			@invoice.variants.each do |variant|
				
				request_id = SecureRandom.hex(5)
				puts request_id
				
				item_price = (variant["price_cents"].to_i * product_percent_rate / 100).round(2)
				item_count = variant["count"].to_i
				item = {
					:name => "#{variant["name"]}(#{product.name})",
					# :description => variant["name"],
					:description => "#{variant["name"]}(#{product.name})",
					:quantity      => item_count,
					:amount => item_price,
					# :category => :Digital
				}
				items << item
				billed_price += item_price * item_count
			end
		else
			
			amount_price = (product.price_cents * product_percent_rate / 100).round(2)
			item = {
				:name => product.name,
				:description => product.name,
				:quantity      => 1,
				:amount => amount_price,
				# :category => :Digital
			}
			items << item
			billed_price += amount_price
		end

		# travelog credit 
		reward_credit = 0
		if current_user.reward_credit >= 5
			reward_credit = 5
			# convert by currency
			if @invoice.currency.downcase != "usd"
				rate = session["currency-convert-#{@invoice.currency}"].to_f
				reward_credit = (5 * rate).round(2)
				@invoice.reward_credit = reward_credit
			end
			@invoice.is_reward_credit = true
			@invoice.reward_credit = reward_credit
			
			item = {
				:name => 'Travelog Credit',
				:description => 'Travelog Credit',
				:quantity      => 1,
				:amount => (-1) * reward_credit
				# :category => :Digital
			}
			items << item
			billed_price -= reward_credit
		end

		coupon_amounts = 0
		if @invoice.coupon_id.present?
			coupon_amounts = @invoice.coupon_amounts
			item = {
				:name => 'Coupon',
				:description => 'Coupon',
				:quantity      => 1,
				:amount => (-1) * @invoice.coupon_amounts
				# :category => :Digital
			}
			items << item
			billed_price -= coupon_amounts
		end

		billed_price = billed_price.round(2)		
		payment_request = Paypal::Payment::Request.new(
			:currency_code => @invoice.currency,   # 
			:description   => 'booking travel',    # item description
			:quantity      => 1,      # item quantity
			:items => items,
			# :amount        => @invoice.amount_cents / 100 - reward_credit - coupon_amounts 
			:amount        => billed_price
		)
		@invoice.billed = billed_price

		begin
			response = request.setup(
				payment_request,
				invoices_success_checkout_url,
				# invoices_cancel_checkout_url,
				new_invoice_url(params),
				paypal_options  # Optional
			)

			if response.ack == 'Success'
				
				@invoice.token = response.token
				@invoice.is_sent_email_unprocessed = false
				@invoice.save!

				# AbandonedCheckoutJob.perform_later @invoice.id
				#AbandonedCheckoutJob.set(wait: 1.minute).perform_later @invoice.id

				# AbandonedCheckoutJob.set(wait: 1.minute).perform_later @invoice.id

				contact_detail = ContactDetail.new(contact_detail_params)
				contact_detail.invoice = @invoice
				contact_detail.save!

				redirect_to response.redirect_uri
			else
				flash[:alert] = "There is an error while processing the payment"
				redirect_to product_url
			end  
		rescue Exception => e
			# puts e.response for debugging.
			# print(e.response.details)
			redirect_to new_invoice_url(params)
		end
	end

	def update
		
	end

	def success_checkout

		token = params[:token]
		payer_id = params[:PayerID]
		@invoice = Invoice.find_by_token(token)

		request = Paypal::Express::Request.new(
			:username   => PAYPAL_CONFIG[:username],
			:password   => PAYPAL_CONFIG[:password],
			:signature  => PAYPAL_CONFIG[:signature]
		)

		payment_request = Paypal::Payment::Request.new(
			:currency_code => @invoice.currency,   
			:description   => "New payment for travel booking",
			:quantity      => 1,
			# :amount        => @invoice.amount_cents.to_i / 100
			:amount        => @invoice.billed
		)

		response = request.checkout!(
			params[:token],
			params[:PayerID],
			payment_request
		)

		gon.is_display_currency_exchange = false
		@currency_symbol = get_all_currency_symbols[@invoice.currency]

		if response.ack == 'Success'
			@invoice.update_attributes(:payer_id => payer_id, :status => "paid", :is_sent_email_unprocessed => true)

			if @invoice.is_reward_credit
				current_user.reward_credit -= 5
				current_user.save
			end
			
			
			@currency_symbols = get_all_currency_symbols

			# receipt_pdf = WickedPdf.new.pdf_from_string(
			# 	render_to_string(pdf: 'receipt', template: 'invoice_mailer/checkout.html.erb')
			# )

			# sending email as backgound job using sidekiq + redis
			# InvoiceMailer.delay_for(10.minutes).send_to_buyer(@invoice)
			# InvoiceMailer.delay_for(10.minutes).send_to_product_owner(@invoice)
			# InvoiceMailer.delay_for(10.minutes).send_to_travelog(@invoice)

			# sending email right now without backgound job
			InvoiceMailer.send_to_buyer(@invoice).deliver_now
			InvoiceMailer.send_to_product_owner(@invoice).deliver_now
			InvoiceMailer.send_to_travelog(@invoice).deliver_now

			flash[:success] = "Checkouted successfully."
			return redirect_to slug_invoice_path(@invoice.token)
		else
			flash[:danger] = "There is an error while processing the payment."
		end

	end

	def show
		@invoice = Invoice.find(params[:id])
		render :success_checkout
	end

	def display
		@invoice = Invoice.find_by_token(params[:slug])
		@product_percent_rate = 1 - @invoice.product_discount.to_f / 100

		@total_billed = @invoice.billed
		if @total_billed == 0.0
			@total_billed = @invoice.amount_cents.to_f / 100
			@total_billed -= @invoice.reward_credit if @invoice.is_reward_credit
			@total_billed -= @invoice.coupon_amounts
		end
		
		if current_user.id == @invoice.product.user_id || current_user.id == @invoice.user_id
			render :success_checkout
		else
			redirect_to root_path
		end
		
	end

	def cancel_checkout
		gon.is_display_currency_exchange = false
	end

	def abandoned_checkout
		original_invoice = Invoice.find(params[:id])
		if original_invoice.blank? || original_invoice.user != current_user
			redirect_to root_path
		end
		@invoice = original_invoice.dup
		set_extra_params_for_new

		if @invoice.coupon.present?
			coupon = @invoice.coupon
			if coupon.currency != session[:currency]
				rate = (session["currency-convert-#{session[:currency]}"].to_f / session["currency-convert-#{coupon.currency.upcase}"].to_f)
			else
				rate = 1.0
			end
			@coupon_amounts_with_user_currency = (coupon.amount_cents * rate / 100).round(2)

			# rate for product currency
			product_currency = @invoice.product.currency
			if coupon.currency != product_currency
				rate = (session["currency-convert-#{product_currency}"].to_f / session["currency-convert-#{coupon.currency.upcase}"].to_f)
			else
				rate = 1.0
			end
			@invoice.coupon_amounts = (coupon.amount_cents * rate / 100).round(2)

		end
		

		@invoice_params = {}
		@contact_detail_params = original_invoice.contact_detail
		set_invoice_currency_attributes(@invoice)

		gon.invoice = @invoice
		gon.real_total_with_currency = @invoice.real_total_with_currency
		gon.real_total = @invoice.real_total
		render :template => 'invoices/new'
	end

	private
		
		def invoice_params
			params.require(:invoice).permit(:billing_country, :payment_type, :valid_month, :valid_day, :security_code, 
				:booking_date, :product_id, :currency, :amount_cents, :coupon_id, :coupon_amounts)
		end

		def contact_detail_params
			params.require(:contact_detail).permit(:first_name, :last_name, :email, :phone_number, :message)
		end

		def set_invoice_currency_attributes(invoice)
			if invoice.currency != session[:currency]
				rate = (session["currency-convert-#{session[:currency]}"].to_f / session["currency-convert-#{invoice.currency}"].to_f)
			else
				rate = 1.0
			end

			product_percent_rate = invoice.product.discount
			product_percent_rate = 1 - product_percent_rate.to_f / 100
			

			invoice.price_with_currency = (invoice.amount_cents * rate / 100).round(2)
			invoice.current_currency = session[:currency]
			invoice.currency_rate = rate

			# binding.pry
			invoice.variants.each do |variant|
				variant[:price_with_currency] = (variant[:price_cents].to_f * rate * product_percent_rate / 100).round(2)
				variant[:total_with_currency] = (variant[:price_with_currency] * variant[:count].to_i).round(2)
				variant[:total] = (variant[:price_cents].to_f * product_percent_rate * variant[:count].to_i / 100).round(2)
			end


			invoice.product.set_price_with_currency(rate)
			invoice.real_total = (invoice.amount_cents * product_percent_rate / 100).round(2)
			invoice.real_total_with_currency = (invoice.price_with_currency * product_percent_rate).round(2)
			
			if current_user.reward_credit >= 5
				reward_credit = 5
				invoice.reward_credit_with_currency = reward_credit
				if session[:currency].downcase != "usd"
					rate = session["currency-convert-#{session[:currency]}"].to_f
					invoice.reward_credit_with_currency = (reward_credit * rate).round(2)
				end
				if invoice.currency.downcase != "usd"
					rate = session["currency-convert-#{invoice.currency}"].to_f
					reward_credit = (5 * rate).round(2)
					invoice.reward_credit = reward_credit
				end
				invoice.is_reward_credit = true
				invoice.reward_credit = reward_credit
				invoice.real_total -= invoice.reward_credit
				invoice.real_total_with_currency -= invoice.reward_credit_with_currency

				# adjust the value
				invoice.real_total = invoice.real_total.round(2)
				invoice.real_total_with_currency = invoice.real_total_with_currency.round(2)
			end

			# binding.pry
		end

		def set_extra_params_for_new

			# for cancel checkout
			@variant_params = @invoice.variants.clone

			@invoice.clean_variants
			@product = Product.find(@invoice.product_id)
			@prodcut_image_url = @product.product_attachments[0].attachment.medium.url if @product.product_attachments.present? && @product.product_attachments.count > 0
			@invoice.currency = @product.currency
			gon.is_display_currency_exchange = false
		end

end
