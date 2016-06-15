class AddCouponFieldsToInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :coupon_id, :integer
  	add_column :invoices, :coupon_amounts, :decimal, precision: 5, scale: 2, :default => 0.0
  end
end
