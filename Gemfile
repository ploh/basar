source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
gem 'rails-i18n'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-hotkeys-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

gem 'hamlit'
gem 'hamlit-rails'

gem 'paloma'

gem 'devise'
gem 'devise-i18n'

gem 'cancancan'

gem 'yaml_db'

gem 'sqlite3'

group :development, :test do
  gem 'byebug'
  gem 'database_cleaner', '<= 1.0.1'
  gem 'capybara'
#   gem 'launchy'
  gem 'rspec-rails'
  gem 'autotest-rails'
  gem 'rspec-autotest'
  gem 'simplecov'
#   gem 'minitest', '>= 5.0.0'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'poltergeist'
end

group :development do
  gem 'rails-erd'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger', '>= 0.1.1'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'cucumber-rails-training-wheels'
  gem 'ZenTest'
end

group :cucumber do
  gem 'headless'
end


# heroku deployment
# group :production do
#  gem 'unicorn'
#  gem 'pg'
#  gem 'rails_12factor'
# end
