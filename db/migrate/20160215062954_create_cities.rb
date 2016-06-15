class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
    	t.string :name
    	t.string :bg_cover_img
    	t.string :description
    	t.string :slug
    	t.timestamps null: false
    end
  end
end
