class AddUuidToStoreSettings < ActiveRecord::Migration
  def change
  	add_column :store_settings, :uuid, :string
  	remove_column :store_settings, :phone_line
  	rename_column :store_settings, :phone_hp, :phone_number
  end
end
