class AddRewardCreditToInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :is_reward_credit, :boolean, :default => false
  	add_column :invoices, :reward_credit, :decimal,	precision: 5, scale: 2
  end
end
