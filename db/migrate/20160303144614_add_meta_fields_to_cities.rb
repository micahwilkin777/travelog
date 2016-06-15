class AddMetaFieldsToCities < ActiveRecord::Migration
  def change
  	add_column :cities, :m_title, :text
  	add_column :cities, :m_desc, :text
  	add_column :cities, :m_key, :text
  end
end
