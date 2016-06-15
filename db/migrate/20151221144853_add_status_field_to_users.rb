class AddStatusFieldToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :status, :integer, :limit => 1, :default => 0
  end
end
