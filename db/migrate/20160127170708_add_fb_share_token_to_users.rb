class AddFbShareTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :fb_share_token, :string
  	add_column :users, :is_fb_invited, :boolean, :default => false
  end
end
