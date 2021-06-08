source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem "activesupport", ">= 6.0.3.1"
gem "activerecord", ">= 6.0.3.5"
gem "actionpack", ">= 6.0.3.7"

gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'

gem 'bootsnap', '>= 1.4.2', require: false

gem "influxdb-rails"
gem 'whenever', require: false

gem "sentry-raven"
gem "slack-notifier"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
