class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
    	t.references :user, index: true
    	t.json :attachments
    	t.string :name
    	t.integer :payment_type, :limit => 1
    	t.timestamps null: false
    end
  end
end
