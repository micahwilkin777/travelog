class AddExtraFieldsToInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :billing_email, :string
  	add_column :invoices, :billing_phone, :string
  	remove_column :invoices, :billing_postal_code, :string
  end
end
