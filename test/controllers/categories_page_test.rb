# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require_relative "../test_helper"
require_relative "../dummy/config/environment"

require "devise/test/integration_helpers"
require "rails/test_help"

class CategoriesPageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.find_or_create_by!(email: "categories-page-test@example.com") do |user|
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end

    sign_in @user
  end

  test "mounted categories page renders registered group details" do
    get "/recording_studio_site_categories"

    assert_response :success
    assert_includes response.body, "Site categories"
    assert_includes response.body, "colour"
    assert_includes response.body, "Site colours"
    assert_includes response.body, "Red, Black, Blue"
  end
end
