class CreateProductReviews < ActiveRecord::Migration
  def change
    create_table :product_reviews do |t|
    	t.references :product, index: true
    	t.references :user, index: true
    	t.text :message
      t.timestamps null: false
    end
  end
end
