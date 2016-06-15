class AddMerchantStatusToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :merchant_status, :integer, :limit => 1, :default => 0
  end
end
