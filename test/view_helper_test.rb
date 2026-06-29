# frozen_string_literal: true

require "test_helper"
require "ostruct"

class ViewHelperTest < Minitest::Test
  HelperHost = Class.new do
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::OutputSafetyHelper
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

    result = with_stubbed_flatpack_select_component do |component_class|
      rendered = @helper.recording_studio_site_category_select(form, :colour, attribute_name: :site_colour, searchable: true)

      component = @helper.last_component
      assert_instance_of component_class, component
      assert_equal "page[site_colour]", component.name
      assert_equal %w[Red Black Blue], component.options
      assert_equal "Black", component.value
      assert_equal "Site colours", component.label
      assert_equal "Select Site colours", component.placeholder
      assert_equal "is invalid", component.error
      assert_equal true, component.system_arguments[:searchable]

      rendered
    end

    assert_equal "rendered-select", result
  end

  def test_select_falls_back_to_standard_form_builder_when_flatpack_is_absent
    page = Struct.new(:site_colour, :errors).new("Black", { site_colour: ["is invalid"] })
    form = FallbackForm.new(object_name: "page", object: page)

    result = without_flatpack do
      @helper.recording_studio_site_category_select(
        form,
        :colour,
        attribute_name: :site_colour,
        class: "w-full",
        searchable: true
      )
    end

    assert_includes result, "<label"
    assert_includes result, "Site colours"
    assert_includes result, "<select"
    assert_includes result, "is invalid"
    assert_equal(
      [
        :site_colour,
        %w[Red Black Blue],
        { include_blank: "Select Site colours" },
        { class: "w-full" }
      ],
      form.select_arguments
    )
  end

  private

  FallbackForm = Struct.new(:object_name, :object) do
    attr_reader :select_arguments

    def label(attribute_name, text)
      %(<label for="#{attribute_name}">#{text}</label>).html_safe
    end

    def select(attribute_name, options, select_options = {}, html_options = {})
      @select_arguments = [attribute_name, options, select_options, html_options]
      %(<select name="#{object_name}[#{attribute_name}]"></select>).html_safe
    end
  end

  def with_stubbed_flatpack_select_component
    without_flatpack do
      component_class = Class.new do
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

      flat_pack = Module.new
      select_namespace = Module.new
      select_namespace.const_set(:Component, component_class)
      flat_pack.const_set(:Select, select_namespace)
      Object.const_set(:FlatPack, flat_pack)

      yield component_class
    end
  ensure
    Object.send(:remove_const, :FlatPack) if Object.const_defined?(:FlatPack, false)
  end

  def without_flatpack
    previous_flat_pack = Object.const_get(:FlatPack) if Object.const_defined?(:FlatPack, false)
    Object.send(:remove_const, :FlatPack) if previous_flat_pack

    yield
  ensure
    Object.send(:remove_const, :FlatPack) if Object.const_defined?(:FlatPack, false)
    Object.const_set(:FlatPack, previous_flat_pack) if previous_flat_pack
  end
end
