# frozen_string_literal: true

require "test_helper"
require "ostruct"

unless defined?(FlatPack::Select::Component)
  module FlatPack
    module Select
      class Component
        attr_reader :name, :options, :value, :label, :placeholder, :error, :system_arguments

        def initialize(name:, options:, value: nil, label: nil, placeholder: nil, error: nil, **system_arguments)
          @name = name
          @options = options
          @value = value
          @label = label
          @placeholder = placeholder
          @error = error
          @system_arguments = system_arguments
        end
      end
    end
  end
end

class ViewHelperTest < Minitest::Test
  HelperHost = Class.new do
    include RecordingStudioSiteCategories::ViewHelper

    attr_reader :last_component

    def render(component)
      @last_component = component
      "rendered-select"
    end
  end

  def setup
    RecordingStudioSiteCategories.reset!
    RecordingStudioSiteCategories.register_group(
      key: :colour,
      label: "Site colours",
      items: %w[Red Black Blue],
      source: "Test"
    )
    @helper = HelperHost.new
  end

  def teardown
    RecordingStudioSiteCategories.reset!
  end

  def test_label_items_options_and_valid_helpers_delegate_to_registry
    assert_equal "Site colours", @helper.recording_studio_site_category_label(:colour)
    assert_equal %w[Red Black Blue], @helper.recording_studio_site_category_items(:colour)
    assert_equal %w[Red Black Blue], @helper.recording_studio_site_category_options(:colour)
    assert @helper.recording_studio_site_category_valid?(:colour, "Red")
    refute @helper.recording_studio_site_category_valid?(:colour, "Green")
  end

  def test_select_builds_flatpack_component_from_form_object
    page = Struct.new(:site_colour, :errors).new("Black", { site_colour: ["is invalid"] })
    form = OpenStruct.new(object_name: "page", object: page)

    result = @helper.recording_studio_site_category_select(form, :colour, attribute_name: :site_colour, searchable: true)
    component = @helper.last_component

    assert_equal "rendered-select", result
    assert_equal "page[site_colour]", component.name
    assert_equal %w[Red Black Blue], component.options
    assert_equal "Black", component.value
    assert_equal "Site colours", component.label
    assert_equal "Select Site colours", component.placeholder
    assert_equal "is invalid", component.error
    assert_equal true, component.system_arguments[:searchable]
  end
end
