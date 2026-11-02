# frozen_string_literal: true

require "test_helper"
require "devise/test/integration_helpers"

class DummyFlatpackButtonsAndTableTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.find_or_create_by!(email: "flatpack-adoption@example.com") do |user|
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end

    sign_in @user
    @workspace = Workspace.find_or_create_by!(name: "FlatPack Adoption Workspace")
    @root_recording = grant_workspace_admin!(@user, @workspace)
    switch_to_root(@root_recording)
  end

  test "home demo buttons are FlatPack links with url not nested link_to wrappers" do
    get "/"

    assert_response :success
    assert_match %r{href="/recording_studio_site_categories/?}, response.body
    assert_includes response.body, 'href="/pages"'
    assert_includes response.body, "View categories"
    assert_includes response.body, "Manage pages"
    refute_includes response.body, 'class="inline-flex"><button'
  end

  test "pages index new edit and delete are FlatPack buttons with url and turbo delete data" do
    page = record_page!(title: "Adoption Delete Page")

    get "/pages"

    assert_response :success
    assert_includes response.body, 'href="/pages/new"'
    assert_includes response.body, %(href="/pages/#{page.id}/edit")
    assert_includes response.body, %(href="/pages/#{page.id}")
    assert_includes response.body, 'data-turbo-method="delete"'
    assert_includes response.body, 'data-turbo-confirm="Delete Adoption Delete Page?"'
    refute_includes response.body, 'class="inline-flex" data-turbo-method'
  end

  test "page form cancel is a FlatPack button url to pages" do
    get "/pages/new"

    assert_response :success
    assert_includes response.body, "Cancel"
    assert_includes response.body, 'href="/pages"'
    refute_includes response.body, 'class="inline-flex"><button'
  end

  test "helpers validity demo uses FlatPack table output" do
    get "/helpers"

    assert_response :success
    assert_includes response.body, "Value"
    assert_includes response.body, "Valid?"
    assert_includes response.body, "Usage"
    assert_includes response.body, "Red"
    assert_includes response.body, "Green"
    assert_includes response.body, "recording_studio_site_category_valid?(:colour,"
    assert_includes response.body, "--table-border-color"
    refute_includes response.body, "border-collapse rounded-lg border border-slate-200"
  end

  private

  def record_page!(title:)
    page = Page.new(title: title, site_colour: "Red")
    RecordingStudio.record!(
      action: "created",
      recordable: page,
      root_recording: @root_recording,
      parent_recording: @root_recording,
      actor: @user
    )
    page
  end

  def switch_to_root(root_recording)
    patch "/recording_studio_root_switchable/v1/root_switch", params: {
      scope: "all_workspaces",
      root_switch: {
        root_recording_id: root_recording.id,
        return_to: "/pages"
      }
    }

    assert_redirected_to "/pages"
  end
end
