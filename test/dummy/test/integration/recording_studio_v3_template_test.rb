# frozen_string_literal: true

require "test_helper"

class RecordingStudioV3TemplateTest < ActiveSupport::TestCase
  test "dummy app keeps recording studio declarations and category initializer" do
    assert RecordingStudio.validate_recordable_declarations!
    assert_equal ["Workspace"], RecordingStudio.root_recordable_types
    assert_equal ["Workspace", "Folder"], RecordingStudio.allowed_parent_types_for("Page")
    assert_equal "Site colours", RecordingStudioSiteCategories.label_for(:colour)
    assert_equal %w[Red Black Blue], RecordingStudioSiteCategories.values_for(:colour)
  end

  test "dummy schema includes pages table" do
    assert ActiveRecord::Base.connection.table_exists?(:pages)
  end

  test "dummy seeds keep the page recordable" do
    Current.actor = nil

    load Rails.root.join("db/seeds.rb").to_s

    page = Page.find_by!(title: "Getting Started")
    page_recording = RecordingStudio::Recording.find_by!(recordable: page)
    assert_nil Current.actor
    assert_equal page, page_recording.recordable
  ensure
    Current.actor = nil
  end
end
