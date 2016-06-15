class AbandonedCheckoutWorker
	include Sidekiq::Worker

	def perform(invoice_id)
    invoice = Invoice.find_by_id(invoice_id)
    return if invoice.blank?
    if invoice.payer_id.present? && invoice.token.present?
    	InvoiceMailer.send_abandoned(invoice).deliver
    	invoice.is_sent_email_unprocessed = true
    	invoice.save
    end
  end
end