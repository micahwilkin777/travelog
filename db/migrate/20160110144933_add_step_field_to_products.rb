class AddStepFieldToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :step, :integer, :limit => 1, :default => 0
  end
end
