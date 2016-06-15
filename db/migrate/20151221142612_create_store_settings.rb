class CreateStoreSettings < ActiveRecord::Migration
  def change
    create_table :store_settings do |t|
    	t.references :user, index: true
    	t.string :store_name
    	t.string :store_username
    	t.string :phone_hp
    	t.string :phone_line
    	t.string :store_img
    	t.string :address
    	t.string :city
    	t.string :state
      t.timestamps null: false
    end
  end
end
