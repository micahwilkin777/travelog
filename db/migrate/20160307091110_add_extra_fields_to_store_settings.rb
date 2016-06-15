class AddExtraFieldsToStoreSettings < ActiveRecord::Migration
  def change
  	add_column :store_settings, :mobile_number, :string
  	add_column :store_settings, :website, :string
  	add_column :store_settings, :merchant_type, :integer, :limit => 1, :default => 0
  	add_column :store_settings, :know_us_text, :text
  	add_column :store_settings, :currency, :string
  end
end
