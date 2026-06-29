# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require_relative "test_helper"
require_relative "dummy/config/environment"

require "devise/test/integration_helpers"
require "rails/test_help"

class DummyPagesFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.find_or_create_by!(email: "pages-flow-test@example.com") do |user|
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end

    sign_in @user
    @workspace = Workspace.find_or_create_by!(name: "AAA Flow Workspace")
    @expected_root_recording = RecordingStudio.root_recording_for(Workspace.order(:name).first!)
  end

  test "create records a page through recording studio and stores the selected site colour" do
    assert_difference(["Page.count", "RecordingStudio::Recording.count"], 1) do
      post pages_path, params: {
        page: {
          title: "Created Through Flow",
          site_colour: "Blue",
          ignored: "value"
        }
      }
    end

    page = Page.find_by!(title: "Created Through Flow")
    recording = RecordingStudio::Recording.find_by!(recordable: page)

    assert_redirected_to pages_path
    assert_equal "Blue", page.site_colour
    assert_equal @expected_root_recording.id, recording.root_recording_id
  end

  test "invalid create re-renders the form" do
    assert_no_difference("Page.count") do
      post pages_path, params: {
        page: {
          title: "Bad Colour Page",
          site_colour: "Green"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "is not a valid Site colours"
  end

  test "update saves strong parameters on an existing page" do
    page = Page.create!(title: "Editable Page", site_colour: "Red")

    patch page_path(page), params: {
      page: {
        title: "Updated Page",
        site_colour: "Black",
        ignored: "value"
      }
    }

    assert_redirected_to pages_path
    assert_equal "Updated Page", page.reload.title
    assert_equal "Black", page.site_colour
  end
end
