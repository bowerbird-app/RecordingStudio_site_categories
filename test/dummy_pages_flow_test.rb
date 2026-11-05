# frozen_string_literal: true

require_relative "dummy/test/test_helper"
require "devise/test/integration_helpers"

class DummyPagesFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.find_or_create_by!(email: "pages-flow-test@example.com") do |user|
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end

    sign_in @user
    @workspace = Workspace.find_or_create_by!(name: "AAA Flow Workspace")
    @expected_root_recording = grant_workspace_admin!(@user, @workspace)
    switch_to_root(@expected_root_recording)
  end

  test "create records a page through recording studio" do
    assert_difference(["Page.count", "RecordingStudio::Recording.count"], 1) do
      post "/pages", params: {
        page: {
          title: "Created Through Flow",
          site_colour: "Red",
          site_publications: ["Magazine"],
          ignored: "value"
        }
      }
    end

    page = Page.find_by!(title: "Created Through Flow")
    recording = RecordingStudio::Recording.find_by!(recordable: page)

    assert_redirected_to "/pages"
    assert_equal @expected_root_recording.id, recording.root_recording_id
    assert_equal "Red", page.site_colour
    assert_equal ["Magazine"], page.site_publications
  end

  test "invalid create re-renders the form" do
    assert_no_difference("Page.count") do
      post "/pages", params: {
        page: {
          title: ""
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "prevented this page from being saved"
  end

  test "create rejects a colour outside the registered group" do
    assert_no_difference("Page.count") do
      post "/pages", params: {
        page: {
          title: "Off palette",
          site_colour: "Green"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "update saves strong parameters on an existing page" do
    page = record_page!(title: "Editable Page", site_colour: "Black")

    patch "/pages/#{page.id}", params: {
      page: {
        title: "Updated Page",
        site_colour: "Blue",
        ignored: "value"
      }
    }

    updated = Page.order(created_at: :desc).find_by!(title: "Updated Page")

    assert_redirected_to "/pages"
    assert_equal "Blue", updated.site_colour
  end

  test "update 404s when the page is not on the current root" do
    page = Page.create!(title: "Orphan Page")

    patch "/pages/#{page.id}", params: {
      page: {
        title: "Should Not Save"
      }
    }

    assert_response :not_found
    assert_equal "Orphan Page", page.reload.title
  end

  test "update 404s when the page belongs to another workspace" do
    other_workspace = Workspace.find_or_create_by!(name: "ZZZ Other Flow Workspace")
    other_root = grant_workspace_admin!(@user, other_workspace)
    page = Page.new(title: "Other Root Page", site_colour: "Red")
    RecordingStudio.record!(
      action: "created",
      recordable: page,
      root_recording: other_root,
      parent_recording: other_root,
      actor: @user
    )

    patch "/pages/#{page.id}", params: {
      page: {
        title: "Should Not Save"
      }
    }

    assert_response :not_found
    assert_equal "Other Root Page", page.reload.title
  end

  test "destroy trashes an existing page" do
    page = record_page!(title: "Disposable Page")
    recording = RecordingStudio::Recording.find_by!(recordable: page)

    assert_no_difference("Page.count") do
      delete "/pages/#{page.id}"
    end

    assert_redirected_to "/pages"
    assert recording.reload.trashed_at.present?
  end

  test "destroy 404s when the page is not on the current root" do
    page = Page.create!(title: "Orphan Delete Page")

    assert_no_difference("Page.count") do
      delete "/pages/#{page.id}"
    end

    assert_response :not_found
    assert Page.exists?(page.id)
  end

  private

  def record_page!(title:, site_colour: "Red")
    page = Page.new(title: title, site_colour: site_colour)
    RecordingStudio.record!(
      action: "created",
      recordable: page,
      root_recording: @expected_root_recording,
      parent_recording: @expected_root_recording,
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
