# frozen_string_literal: true

require "test_helper"

class RecordingStudioSiteCategoriesTest < Minitest::Test
  def setup
    RecordingStudioSiteCategories.reset!
  end

  def teardown
    RecordingStudioSiteCategories.reset!
  end

  def test_version_exists
    refute_nil RecordingStudioSiteCategories::VERSION
  end

  def test_module_level_registry_helpers_delegate
    RecordingStudioSiteCategories.register_group(
      key: :colour,
      label: "Site colours",
      items: %w[Red Blue],
      source: "Test"
    )

    assert_equal [:colour], RecordingStudioSiteCategories.group_keys
    assert_equal "Site colours", RecordingStudioSiteCategories.label_for(:colour)
    assert_equal %w[Red Blue], RecordingStudioSiteCategories.values_for(:colour)
    assert RecordingStudioSiteCategories.valid?(:colour, :Red)
  end
end
