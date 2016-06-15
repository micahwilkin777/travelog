class CreateStoreImages < ActiveRecord::Migration
  def change
    create_table :store_images do |t|
    	t.references :store_setting, index: true
    	t.string :store_img
      t.timestamps null: false
    end
  end
end
