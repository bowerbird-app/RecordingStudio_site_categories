# frozen_string_literal: true

require "test_helper"
require "devise/test/integration_helpers"

class CategorySelectTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.find_or_create_by!(email: "category-select-test@example.com") do |user|
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end

    sign_in @user
    @workspace = Workspace.create!(name: "Category Select Workspace")
    grant_workspace_admin!(@user, @workspace)
  end

  test "new page form renders the real FlatPack category select" do
    get new_page_path

    assert_response :success
    assert defined?(::FlatPack::Select::Component)
    assert_includes response.body, "Site colours"
    assert_includes response.body, "Red"
    assert_includes response.body, "Black"
    assert_includes response.body, "Blue"
    assert_includes response.body, "Publication types"
    assert_includes response.body, "Magazine"
    refute_includes response.body, "translation missing"
  end

  test "failed create keeps the real FlatPack select name options value label placeholder error and searchable" do
    post pages_path, params: {
      page: {
        title: "Off palette",
        site_colour: "Green"
      }
    }

    assert_response :unprocessable_entity
    html = response.body

    assert_includes html, 'name="page[site_colour]"'
    assert_includes html, "Red"
    assert_includes html, "Black"
    assert_includes html, "Blue"
    assert_includes html, 'value="Green"'
    assert_includes html, "Site colours"
    assert_includes html, "Select Site colours"
    assert_includes html, "is not a valid Site colours"
    assert_includes html, 'data-flat-pack--select-searchable-value="true"'
  end
end
