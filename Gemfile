source 'http://rubygems.org'

ruby '2.6.3'

gem 'rails', '4.2.11.3'
gem 'jquery-rails'

# PostgreSQL database and activerecord querying
gem 'activerecord'
gem 'activerecord-session_store'
# Encryption
gem 'aes'

# Gems used only for assets and not required in production environments by default
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# Use mysql2 for local development
group :development do
  gem 'mysql2', '0.5.3'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'pg', '1.2.3'
end
