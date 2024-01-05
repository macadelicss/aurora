source "https://rubygems.org"

ruby Pathname.new(__dir__).join(".ruby-version").read.strip

gem "rails", "~> 7.1.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "rspec-rails"
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "selenium-webdriver"
  gem "capybara"
end
