# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.9'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 5.3.2'
gem 'devise'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.8', '>= 5.2.8.1'
gem 'rails-i18n'
gem 'redis', '~> 4.0'
gem 'sassc-rails'
gem 'shog'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop-rails', require: false

  gem 'database_cleaner'
  gem 'factory_bot_rails', '5.2.0'
  gem 'faker'
  gem 'rspec-rails', '~> 4.1.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'action-cable-testing'
  gem 'shoulda-matchers'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
