# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in recording_studio_site_categories.gemspec
gemspec

# recording_studio and flat_pack are not published to RubyGems.
gem "flat_pack", github: "bowerbird-app/flatpack", tag: "v0.1.341"
gem "recording_studio", github: "bowerbird-app/RecordingStudio", tag: "v6.3.0"

gem "devise"
gem "puma"
gem "sprockets-rails"

group :development, :test do
  gem "bundler-audit", require: false
  gem "debug"
  gem "simplecov", require: false
end

group :development do
  gem "rubocop", "1.81.7", require: false
  gem "rubocop-ast", "1.48.0", require: false
  gem "rubocop-rails", require: false
end
