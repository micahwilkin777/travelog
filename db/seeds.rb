# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# if Location.count == 0
# 	Location.create([{ state: 'Kuala Lumpur - Selangor'} , { state: 'Langkawi' } , { state: 'Penang' }])
# end

# location = Location.first
# Product.update_all("location_id = '#{location.id}'")

# 10.times do |i|
# 	user = User.new({:email => "test#{i.to_s}@gmail.com", :password => 'tigertiger'})
# 	user.save
# 	profile = Profile.new({:user_id => user.id, :first_name => "test#{i.to_s}", :last_name => "test#{i.to_s}"})
# 	profile.save
# 	product_review = ProductReview.new({:user_id => user.id, :product_id => 36, :message => "test" * i})
# 	product_review.save
# end


# add friendly id for previous products

Product.find_each(&:save)