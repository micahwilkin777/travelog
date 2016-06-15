class TripsController < ApplicationController

	def layout_by_resource
		"product"
	end

	def index
		# @invoices = Invoice.where.not(:payer_id => nil)
		current_time = DateTime.now.strftime('%F')
		@upcomming_invoices = Invoice.includes(:product).where.not(:payer_id => nil, :token => nil).where("booking_date > ?", current_time).where(:user_id => current_user.id).order('booking_date asc')
		@previous_invoices = Invoice.includes(:product).where.not(:payer_id => nil, :token => nil).where("booking_date <= ?", current_time).where(:user_id => current_user.id).order('booking_date desc')
		# @upcomming_invoices = Invoice.includes(:product).where(:status => 1).where.not(:payer_id => nil, :token => nil).where("booking_date > ?", current_time).where(:user_id => current_user.id).order('booking_date asc')
		# @previous_invoices = Invoice.includes(:product).where(:status => 1).where.not(:payer_id => nil, :token => nil).where("booking_date <= ?", current_time).where(:user_id => current_user.id).order('booking_date desc')
		@upcomming_invoices.each do |invoice|
			invoice.set_product_attributes
			invoice.set_total_billed
		end
		@previous_invoices.each do |invoice|
			invoice.set_product_attributes
			invoice.set_total_billed
		end
	end

	def update_status
		invoice = Invoice.find(params[:trip_id])
		status = params[:status]
		invoice.status = status
		invoice.save
		render :nothing => true, :status => 200, :content_type => 'text/html'
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
		if current_user.id == @invoice.user_id
			render :checkout
		else
			redirect_to root_path
		end
	end
	

end
