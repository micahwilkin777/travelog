class AddRewardCreditToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :reward_credit, :integer, :default => 0
  end
end
