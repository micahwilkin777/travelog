class InvoiceMailer < ActionMailer::Base
	default from: "Travelog <support@travelog.com>"
	include ApplicationHelper
	
	def checkout(invoice, user_type)
		@invoice = invoice
		@currency_symbols = get_all_currency_symbols
		
		# attachments["receipt.pdf"] = WickedPdf.new.pdf_from_string(
		# 	render_to_string(pdf: 'receipt', template: 'invoice_mailer/checkout.html.erb')
		# )
		if user_type == 1

			mail(:to => invoice.contact_detail.email, :subject => "Your Booking at Travelog.com")
		elsif user_type == 2
			mail(:to => invoice.product.user.email, :subject => "Your Booking at Travelog.com")
		elsif user_type == 3
			mail(:to => "no-reply@travelog.com", :subject => "Your Booking at Travelog.com")
		end

		
	end

	def send_to_buyer(invoice)
		@invoice = invoice
		@currency_symbols = get_all_currency_symbols
		@product_percent_rate = 1 - @invoice.product_discount.to_d / 100

		#attachments["receipt.pdf"] = receipt_pdf
		mail(:to => invoice.user.email, :subject => "Your Booking at Travelog.com #" + @invoice.payer_id)
	end

	def send_to_product_owner(invoice)
		@invoice = invoice
		@currency_symbols = get_all_currency_symbols
		@product_percent_rate = 1 - @invoice.product_discount.to_d / 100

		#attachments["receipt.pdf"] = receipt_pdf
		mail(:to => invoice.product.user.email, :subject => "Your Received booking from Travelog.com #" + @invoice.payer_id)
	end

	def send_to_travelog(invoice)
		@invoice = invoice
		@currency_symbols = get_all_currency_symbols
		@product_percent_rate = 1 - @invoice.product_discount.to_d / 100
		
		#attachments["receipt.pdf"] = receipt_pdf
		mail(:to => "no-reply@travelog.com", :subject => "Travelog received new booking #" + @invoice.payer_id)
	end

	def send_abandoned(invoice)
		@invoice = invoice
		@currency_symbols = get_all_currency_symbols
		@abandoned_link = "#{CUSTOM_CONFIG[:root_url]}invoices/#{invoice.id}/abandoned_checkout"
		mail(:to => invoice.product.user.email, :subject => "Please complete abandoned checkout")
	end
end