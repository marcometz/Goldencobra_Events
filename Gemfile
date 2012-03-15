source "http://rubygems.org"

# Declare your gem's dependencies in goldencobra-events.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'goldencobra', :git => "git://github.com/ikusei/Goldencobra.git"
gem 'compass-rails'

gem "rspec-rails", :group => [:test, :development] # rspec in dev so the rake tasks run properly
gem 'roadie'
gem 'uglifier', '>= 1.0.3'
#gem 'premailer-rails3'

group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'guard-annotate'
  gem 'pry'
  gem 'rails-pry'
  gem 'git-pivotal'
  gem 'hirb'
end

group :test do
  gem 'sqlite3'
  gem 'cucumber'
  gem 'cucumber-rails', '~> 1.2.1' 
  gem 'factory_girl', '~> 2.3.2'
  gem "factory_girl_rails", "~> 1.4.0"
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'rb-fsevent', :git => 'git://github.com/ttilley/rb-fsevent.git', :branch => 'pre-compiled-gem-one-off'
  gem 'growl' 
  gem 'launchy'
end