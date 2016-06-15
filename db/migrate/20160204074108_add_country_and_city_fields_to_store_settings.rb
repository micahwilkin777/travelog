class AddCountryAndCityFieldsToStoreSettings < ActiveRecord::Migration
  def change
  	add_column :store_settings, :country, :string
  end
end
