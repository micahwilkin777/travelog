class AddMerchantStatusToInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :merchant_status, :integer, :limit => 1, :default => 0
  end
end
