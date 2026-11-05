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
    assert_equal "0.4.0", RecordingStudioSiteCategories::VERSION
  end

  def test_gemspec_stays_free_of_a_runtime_recording_studio_dependency
    gemspec = File.read(File.expand_path("../recording_studio_site_categories.gemspec", __dir__))

    refute_includes gemspec, 'spec.add_dependency "recording_studio"'
    assert_includes gemspec, "runtime RecordingStudio dependency"
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
