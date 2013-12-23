source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end
group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'childprocess'
  gem "teaspoon"
  gem 'guard-brakeman'
  gem 'forgery'
  gem 'database_cleaner'
end
group :test do
  gem 'rb-notifu'
  gem 'win32console'
  gem 'wdm'
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'timecop'
end
gem 'jquery-rails'
gem 'state_machine'
#gem 'bootstrap-sass'
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem "slim-rails"
gem "thin"
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'state_machine'
gem "ice_cube"
gem 'draper', '~> 1.3'
gem "pundit"
gem 'react-rails'
gem "active_model_serializers"
group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end
