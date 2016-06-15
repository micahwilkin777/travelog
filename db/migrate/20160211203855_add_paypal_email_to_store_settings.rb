class AddPaypalEmailToStoreSettings < ActiveRecord::Migration
  def change
  	add_column :store_settings, :paypal_email, :string
  end
end
