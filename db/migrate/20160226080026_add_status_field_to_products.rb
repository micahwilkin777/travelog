class AddStatusFieldToProducts < ActiveRecord::Migration
  def change
  	remove_column :products, :status
  	add_column :products, :status, :integer, :limit => 1, :default => 1
  end
end
