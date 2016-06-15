class AddMinMaxFieldsToVariants < ActiveRecord::Migration
  def change
  	add_column :variants, :min_count, :integer
  	add_column :variants, :max_count, :integer
  end
end
