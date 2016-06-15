class AddRatingStarToReviews < ActiveRecord::Migration
  def change
  	add_column :product_reviews, :rating_stars, :integer, :limit => 1, :default => 0
  end
end
