# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "simplecov_helper"
require "minitest/autorun"
require "rails"
require "action_controller"
require "action_view"
require "active_model"
require "i18n"
require "yaml"
require "recording_studio_site_categories"

# Load gem English into the I18n backend without appending to I18n.load_path.
# Engine config/locales is on the Rails load path when a host app boots.
engine_locale = File.expand_path("../config/locales/en.yml", __dir__)
I18n.backend.store_translations(:en, YAML.safe_load_file(engine_locale, aliases: true).fetch("en"))

load File.expand_path("../config/routes.rb", __dir__)
require File.expand_path("../app/controllers/recording_studio_site_categories/application_controller", __dir__)
require File.expand_path("../app/controllers/recording_studio_site_categories/categories_controller", __dir__)
