# frozen_string_literal: true

require_relative "../dummy/test/test_helper"
require "devise/test/integration_helpers"

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
    refute_includes response.body, "flat-pack-sidebar-layout"
    assert_includes response.body, "Page navigation"
    assert_includes response.body, "x-mark"
    assert_includes response.body, "Site categories"
    assert_includes response.body, "colour"
    assert_includes response.body, "Site colours"
    assert_includes response.body, "Red, Black, Blue"
  end
end
