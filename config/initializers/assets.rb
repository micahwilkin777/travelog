# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( application_users.css )
Rails.application.config.assets.precompile += %w( application_users.js )

Rails.application.config.assets.precompile += %w( application_product.css )
Rails.application.config.assets.precompile += %w( application_product.js )

Rails.application.config.assets.precompile += %w( application_old.css )
Rails.application.config.assets.precompile += %w( application_old.js )

Rails.application.config.assets.precompile += %w( application_result.css )
Rails.application.config.assets.precompile += %w( application_result.js )

Rails.application.config.assets.precompile += %w( application_detail.css )
Rails.application.config.assets.precompile += %w( application_detail.js )

Rails.application.config.assets.precompile += %w( application_product_new.css )
# Rails.application.config.assets.precompile += %w( application_product.js )


Rails.application.config.assets.precompile += %w( application_merchant.css )
Rails.application.config.assets.precompile += %w( application_merchant.js )

Rails.application.config.assets.precompile += %w( application_user_invite.css )
Rails.application.config.assets.precompile += %w( application_user_invite.js )

Rails.application.config.assets.precompile += %w( application_static.css )
Rails.application.config.assets.precompile += %w( application_static.js )