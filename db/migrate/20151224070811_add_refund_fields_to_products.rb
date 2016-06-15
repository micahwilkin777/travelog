class AddRefundFieldsToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :refund_percent, :integer
  	add_column :products, :refundable, :integer, :limit => 1, :default => 0
  end
end
