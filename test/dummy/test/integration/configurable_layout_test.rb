# frozen_string_literal: true

require "test_helper"
require "devise/test/integration_helpers"

class ConfigurableLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @previous_layout = RecordingStudioSiteCategories.configuration.layout
    @previous_core_layout = RecordingStudio.configuration.layout
    @user = User.find_or_create_by!(email: "layout-categories@example.com") do |user|
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end
    sign_in @user
  end

  teardown do
    RecordingStudioSiteCategories.configuration.layout = @previous_layout
    RecordingStudio.configuration.layout = @previous_core_layout
  end

  test "nil falls through to the core layout and then the default shell" do
    assert_nil RecordingStudioSiteCategories.configuration.layout

    get recording_studio_site_categories.root_path

    assert_response :success
    assert_includes response.body, "Site categories"
    assert_select "body[data-recording-studio-default-layout='true']", count: 1

    RecordingStudio.configuration.layout = "application"

    get recording_studio_site_categories.root_path

    assert_response :success
    assert_includes response.body, "Site categories"
    assert_includes response.body, "<html"
    assert_select "body[data-recording-studio-default-layout]", count: 0
  end

  test "a string layout name wraps the categories index" do
    RecordingStudioSiteCategories.configuration.layout = "application"
    get recording_studio_site_categories.root_path

    assert_response :success
    assert_includes response.body, "Site categories"
    assert_includes response.body, "<html"
    assert_select "body[data-recording-studio-default-layout]", count: 0
  end

  test "a keyword layout callable wraps the categories index" do
    RecordingStudioSiteCategories.configuration.layout = lambda do |controller:|
      raise "wrong controller" unless controller.is_a?(RecordingStudioSiteCategories::CategoriesController)

      "application"
    end
    get recording_studio_site_categories.root_path

    assert_response :success
    assert_includes response.body, "Site categories"
    assert_select "body[data-recording-studio-default-layout]", count: 0
  end

  test "false renders the categories index without a document layout" do
    RecordingStudioSiteCategories.configuration.layout = false
    RecordingStudio.configuration.layout = "recording_studio/default_layout"

    get recording_studio_site_categories.root_path

    assert_response :success
    assert_includes response.body, "Site colours"
    refute_match(/<html/i, response.body)
    assert_select "body[data-recording-studio-default-layout]", count: 0
  end
end
