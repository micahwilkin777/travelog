class AddIsSentUnprocessedFieldToInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :is_sent_email_unprocessed, :boolean, :default => true
  end
end
