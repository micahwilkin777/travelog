# author : jayesh
# This is used for sync donor email to user MailChimp mail list which user selected during MailChimp account setup
class AbandonedCheckoutJob < ActiveJob::Base
  queue_as :default


  def perform(invoice_id)
    invoice = Invoice.find_by_id(invoice_id)
    return if invoice.blank?
    if invoice.payer_id.blank? || invoice.token.blank?
      Rails.logger.debug "Sending email..."
      InvoiceMailer.send_abandoned(invoice).deliver
      Rails.logger.debug "Sent email..."
      invoice.is_sent_email_unprocessed = true
      invoice.save
    end
  end
end
