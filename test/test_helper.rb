# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "simplecov_helper"
require "minitest/autorun"
require "rails"
require "action_controller"
require "action_view"
require "active_model"
require "i18n"
require "recording_studio_site_categories"

locale_path = File.expand_path("../config/locales/en.yml", __dir__)
I18n.load_path << locale_path unless I18n.load_path.map { |path| File.expand_path(path) }.include?(locale_path)
I18n.backend.load_translations

load File.expand_path("../config/routes.rb", __dir__)
require File.expand_path("../app/controllers/recording_studio_site_categories/application_controller", __dir__)
require File.expand_path("../app/controllers/recording_studio_site_categories/categories_controller", __dir__)
