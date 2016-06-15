class AddbilledFieldToInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :billed, :decimal, precision: 8, scale: 2, :default => 0.0
  	add_column :invoices, :product_discount, :integer, :default => 100
  end
end
