class AddExtraFieldsToProducts < ActiveRecord::Migration
  def change
  	# add_column :products, :title, :string, :limit => 1, :default => 0
  	add_column :products, :description, :text
  	add_column :products, :highlight, :text
  	add_column :products, :price_cents, :integer
  	add_column :products, :zip, :integer
  	add_column :products, :country, :string
  	add_column :products, :state, :string
  	add_column :products, :city, :string
  	add_column :products, :address, :string
  	add_column :products, :apt, :string
  	add_column :products, :refund_day, :integer
  	add_column :products, :status, :integer, :limit => 1, :default => 0
  	add_column :products, :currency, :string
  end
end
