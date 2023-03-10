source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "simple_active_link_to"
gem "awesome_print"
gem "bootsnap", require: false
gem "devise"
gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "redis", "~> 4.0"
gem "rolify", "~> 6.0"
gem "smarter_csv"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :production do
  gem "rack-timeout"
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "pry-rails"
  gem "rack-mini-profiler"
  gem "rspec-rails"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "standard", require: false
  gem "web-console"
end

group :development do
  gem "annotate"
  gem "bullet"
  gem "rails_db", ">= 2.3.1"
  gem "rails-erd"
end
