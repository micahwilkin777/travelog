require 'money'
require 'money/bank/google_currency'

module ApplicationHelper
	def site_name
		"Book Tours, Sightseeing, Activities, Things to do - Travelog.com"
	end

	def get_location_list
		countries = Product.select(:country).distinct.where("country is not null and country <> ''").pluck(:country)
		cities = Product.select(:city).distinct.where("city is not null and city <> ''").pluck(:city)
		countries += cities
	end

	def get_currency_symbol(currency)
		ret = 'MYR'
		case currency.upcase
		when 'USD'
			ret = '$'
		when 'MYR'
			ret = 'RM'
		when 'SGD'
			ret = '$'
		when 'THB'
			ret = '฿'
		when 'PHP'
			ret = '$'
		when 'TWD'
			ret = 'NT$'
		end
		ret
	end

	def get_product_category_name(category_id)
    category = ProductCategory.find(category_id)
    category.name if category.present?
  end

  def get_country_list
  	ret = [{:country => 'Malaysia'},{:country => 'Thailand'},{:country => 'Indonesia'},{:country => 'Singapore'},{:country => 'Philipines'},{:country => 'Pakistan'},{:country => 'Nepal'},{:country => 'Myanmar'},{:country => 'Mongolia'},{:country => 'Maldives'},{:country => 'Laos'},{:country => 'South Korea'},{:country => 'Japan'},{:country => 'India'},{:country => 'Taiwan'},{:country => 'Hong Kong'},{:country => 'Cambodia'},{:country => 'Brunei Darulssalam'},{:country => 'Bhutan'},{:country => 'Vietnam'},{:country => 'Sri Lanka'}]
  end

  def get_currency_list
  	ret = [{:currency => 'MYR'}, {:currency => 'USD'}, {:currency => 'SGD'}, {:currency => 'THB'}, 
  				{:currency => 'PHP'}, {:currency => 'TWD'}]
  	# ret = [{:currency => 'USD'}, {:currency => 'MYR'}, {:currency => 'SGD'}]
  end

  def get_all_currencies
  	[ "MYR", "USD", "SGD", "THB", "PHP", "TWD" ]
  	# [ "USD", "MYR", "SGD" ]
  end

  def get_all_currency_symbols

  	{ "USD" => "$", "MYR" => "RM", "SGD" => "$", "THB" => "฿", "PHP" => "₱", "TWD" => "NT$" }
  end

  def get_all_cities
  	["Kuala Lumpur", "Johor", "Kedah", "Kelantan", "Melaka", "Negeri Sembilan", "Pahang", "Perak", "Perlis", "Pulau Pinang", "Sabah", "Sarawak", "Selangor", "Terengganu", "Labuan"]
  end

	def get_currency_rate(from_currency, to_currency)
		bank = Money::Bank::GoogleCurrency.new
		rate = bank.get_rate(from_currency, to_currency)
	end

	def get_month_name(month)
		ret = 'Jan'
		case month
		when 1
			ret = 'Jan'
		when 2
			ret = 'Feb'
		when 3
			ret = 'Mar'
		when 4
			ret = 'Apr'
		when 5
			ret = 'May'
		when 6
			ret = 'Jun'
		when 7
			ret = 'Jul'
		when 8
			ret = 'Aug'
		when 9
			ret = 'Sep'
		when 10
			ret = 'Oct'
		when 11
			ret = 'Nov'
		when 12
			ret = 'Dec'
		end
		ret
	end

end
