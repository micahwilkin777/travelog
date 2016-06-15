Rails.application.routes.draw do

 
	devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks",
																			:registrations => "registrations", :invitations => 'invitations'}

	match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]

	get '/users/invitation/invite' => 'users#invite'
	get '/users/fbshare' => 'users#fbshare'
	get '/users/fbshare_accept' => 'users#fbshare_accept'
	root 'home#index'

	# get 'products/result' => 'products#result'
	# post 'products/result' => 'products#result'
	# post 'products/result_filter' => 'products#result_filter'
	post 'home/search' => 'home#search'
	post 'set_currency' => 'application#set_currency'
	# get 'set_currency' => 'application#set_currency'

	post '/home_products' => 'home#home_products'

	post 'twilio/voice' => 'twilio#voice'
	post 'notifications/notify' => 'notifications#notify'
	post 'twilio/status' => 'twilio#status'
	
	resources :products do
		member do
			match "edit_basic",  via: [:get]
			match "edit_description",  via: [:get]
			match "edit_location",  via: [:get]
			match "edit_photo",  via: [:get]
			match "edit_price",  via: [:get]
			post "write_comment" => 'products#write_comment'
			post "remove_comment" => 'products#remove_comment'
			match "set_status", via: [:post]
		end
	end

	resources :cities do
		member do
			match "category", via: [:get]
		end
	end

	resource :place do
		
		# get 'all' => 'places#search_all'
		# post 'all' => 'places#search_all'

		get ':slug' => 'places#search_place'
		post ':slug' => 'places#search_place'
	end
	
	resources :store
	resources :product_attachments
	resources :store_images
	resources :user_avatars
	resources :profile_documents
	resources :account_documents

	post 'invoices/new' => 'invoices#new'
	get 'invoices/success_checkout' => "invoices/success_checkout"
	get 'invoices/cancel_checkout' => "invoices/cancel_checkout"


	get 'invoices/checkout/:slug' => 'invoices#display', :as => 'slug_invoice'
	resources :invoices do
		member do
			match 'abandoned_checkout', via: [:get]
		end
	end
	resource :invoices do

	end



	get 'become_merchant' => 'users#become_merchant'
	post 'become_merchant' => 'users#become_merchant'
	get 'merchant' => 'users#merchant_landing'
	get 'profile' => 'users#profile'
	post 'profile' => 'users#profile'
	patch 'profile' => 'users#profile'
	get 'profile/avatar' => 'users#profile_avatar'
	post 'profile/avatar' => 'users#profile_avatar'
	patch 'profile/avatar' => 'users#profile_avatar'
	get 'profile/security' => 'users#profile_security'
	post 'profile/security' => 'users#profile_security'
	patch 'profile/security' => 'users#profile_security'

	resource :user do
		# match 'profile_document', via: [:get, :post, :patch]
		match 'account_document', via: [:get, :post, :patch]
		match 'getting_paid', via: [:get, :post, :patch]
	end

	get 'accounts' => 'users#accounts'
	post 'accounts' => 'users#accounts'
	patch 'accounts' => 'users#accounts'
	get 'accounts/photo' => 'users#accounts_photo'
	post 'accounts/photo' => 'users#accounts_photo'
	patch 'accounts/photo' => 'users#accounts_photo'


	get 'profile/photos' => 'users#photos'
	post 'profile/photos' => 'users#photos'
	post 'complete_merchant' => 'users#complete_merchant'
	get 'verify_document' => 'users#verify_merchant'
	get 'dashboard' => 'users#dashboard'

	get 'about' => 'users#about'
	get 'blog' => 'users#blog'
	get 'career' => 'users#career'
	get 'contact' => 'users#contact'
	get 'press' => 'users#press'
	get 'terms' => 'users#terms'
	get 'policy' => 'users#policy'
	get 'help' => 'users#help'

	get 'users/verify_store_username' => 'users#verify_store_username'

	# get 'trips' => 'trips#index'
	# get 'reservations' => 'trips#reservations'

	resources :trips do
		post 'update_status' => 'trips#update_status'
	end

	resource :trips do
		get 'checkout/:slug' => 'trips#display', :as => 'slug_trip_checkout'
	end

	resources :reservations do
		post 'update_status' => 'reservations#update_status'
		
	end
	resource :reservations do
		get 'checkout/:slug' => 'reservations#display', :as => 'slug_reservation_checkout'
	end

	get 'reservations/show/:slug' => 'reservations#display', :as => 'slug_reservation'

	resource :coupons do
		match 'get_coupon', via: [:get, :post]
	end

	resource :comments do
		match 'create_comment', via: [:post]
		match 'remove_comment', via: [:post]
		match 'update_comment', via: [:post]
	end
	

	namespace :api, defaults: {format: 'json'}  do
		namespace :v1 do
			resource :users do
				match 'login', via: [:post]
				match 'signup', via: [:post]
			end
			get 'profile' => 'users#profile'
		end
	end
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"
	# root 'welcome#index'

	# Example of regular route:
	#   get 'products/:id' => 'catalog#view'

	# Example of named route that can be invoked with purchase_url(id: product.id)
	#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Example resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Example resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Example resource route with more complex sub-resources:
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', on: :collection
	#     end
	#   end

	# Example resource route with concerns:
	#   concern :toggleable do
	#     post 'toggle'
	#   end
	#   resources :posts, concerns: :toggleable
	#   resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end
end
