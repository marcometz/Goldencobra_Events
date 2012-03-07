source "http://rubygems.org"

# Declare your gem's dependencies in goldencobra-events.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'goldencobra', :git => "git://github.com/ikusei/Goldencobra.git"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


gem "rspec-rails", :group => [:test, :development] # rspec in dev so the rake tasks run properly

gem 'roadie'
#gem 'premailer-rails3'
#gem 'hpricot', "0.8.6"
#gem 'hrpicot'#, '~> 0.8.6', git: 'git://github.com/hpricot/hpricot.git'

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