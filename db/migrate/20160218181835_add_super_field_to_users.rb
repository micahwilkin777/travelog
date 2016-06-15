class AddSuperFieldToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :super, :integer, :limit => 1, :default => 0
  end
end
