# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @previous = RecordingStudioSiteCategories.configuration.layout
    RecordingStudioSiteCategories.reset_configuration!
    @configuration = RecordingStudioSiteCategories.configuration
  end

  def teardown
    RecordingStudioSiteCategories.reset_configuration!
    RecordingStudioSiteCategories.configuration.layout = @previous
  end

  def test_layout_defaults_to_nil_and_rejects_invalid_values
    assert_nil @configuration.layout

    @configuration.layout = false
    assert_equal false, @configuration.layout

    @configuration.layout = "admin"
    assert_equal "admin", @configuration.layout

    callable = ->(controller:) { controller }
    @configuration.layout = callable
    assert_equal callable, @configuration.layout

    assert_raises(ArgumentError) { @configuration.layout = "  " }
    assert_equal callable, @configuration.layout
    assert_raises(ArgumentError) { @configuration.layout = ->(c) { c } }
    assert_equal callable, @configuration.layout
    assert_raises(ArgumentError) { @configuration.layout = Object.new }
    assert_equal callable, @configuration.layout

    @configuration.layout = ->(controller:) { controller.nil? ? :nope : 1 }
    error = assert_raises(ArgumentError) do
      RecordingStudio::Layout.resolve(@configuration.layout, controller: Object.new)
    end
    assert_includes error.message, "layout callable must return"
  end

  def test_configure_yields_the_same_configuration
    yielded = nil
    result = RecordingStudioSiteCategories.configure { |config| yielded = config }

    assert_same RecordingStudioSiteCategories.configuration, yielded
    assert_same RecordingStudioSiteCategories.configuration, result
  end

  def test_engine_controller_uses_recording_studio_layout_macro
    source = File.read(
      File.expand_path("../app/controllers/recording_studio_site_categories/application_controller.rb", __dir__)
    )

    assert_includes source, "if defined?(::RecordingStudio::ControllerLayout)"
    assert_includes source, "recording_studio_layout { RecordingStudioSiteCategories.configuration.layout }"
    assert_includes source, "layout \"recording_studio_site_categories/blank\""
    refute_includes source, "UsesDefaultLayout"
  end
end
