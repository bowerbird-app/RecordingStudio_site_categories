# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "simplecov_helper"
require "minitest/autorun"
require "rails"
require "action_controller"
require "action_view"
require "active_model"
require "recording_studio_site_categories"

load File.expand_path("../config/routes.rb", __dir__)
require File.expand_path("../app/controllers/recording_studio_site_categories/application_controller", __dir__)
require File.expand_path("../app/controllers/recording_studio_site_categories/categories_controller", __dir__)
