# frozen_string_literal: true

require "test_helper"

class ViewHelperTest < Minitest::Test
  HelperHost = Class.new do
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::OutputSafetyHelper
    include RecordingStudioSiteCategories::ViewHelper

    def render(_component)
      "rendered-select"
    end
  end

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

  def test_flatpack_select_is_unavailable_in_the_gem_suite
    refute defined?(::FlatPack)
    refute @helper.recording_studio_site_categories_flatpack_component_available?(
      "FlatPack::Select::Component"
    )
  end

  def test_select_falls_back_to_standard_form_builder_when_flatpack_is_absent
    page = Struct.new(:site_colour, :errors).new("Black", { site_colour: ["is invalid"] })
    form = FallbackForm.new("page", page)

    result = @helper.recording_studio_site_category_select(
      form,
      :colour,
      attribute_name: :site_colour,
      class: "w-full",
      searchable: true
    )

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

  def test_select_placeholder_uses_english_default_in_non_english_locale
    page = Struct.new(:site_colour, :errors).new(nil, {})
    form = FallbackForm.new("page", page)

    with_isolated_i18n_backend do
      I18n.available_locales = %i[en fr]
      I18n.with_locale(:fr) do
        @helper.recording_studio_site_category_select(
          form, :colour, attribute_name: :site_colour
        )

        assert_equal(
          { include_blank: "Select Site colours" },
          form.select_arguments[2]
        )
      end
    end
  end

  def test_select_placeholder_follows_translated_locale_string
    page = Struct.new(:site_colour, :errors).new(nil, {})
    form = FallbackForm.new("page", page)

    with_isolated_i18n_backend do
      I18n.available_locales = %i[en fr]
      I18n.backend.store_translations(
        :fr,
        recording_studio: {
          site_categories: {
            select: {
              # rubocop:disable-next Style/FormatStringToken
              placeholder: "Choisir %{label}"
            }
          }
        }
      )

      I18n.with_locale(:fr) do
        @helper.recording_studio_site_category_select(
          form, :colour, attribute_name: :site_colour
        )

        assert_equal(
          { include_blank: "Choisir Site colours" },
          form.select_arguments[2]
        )
      end
    end
  end

  private

  def with_isolated_i18n_backend
    original_backend = I18n.backend
    original_locale = I18n.locale
    original_available_locales = I18n.available_locales.dup
    I18n.backend = I18n::Backend::Simple.new
    locale_path = File.expand_path("../config/locales/en.yml", __dir__)
    I18n.backend.store_translations(:en, YAML.safe_load_file(locale_path, aliases: true).fetch("en"))
    yield
  ensure
    I18n.backend = original_backend
    I18n.locale = original_locale
    I18n.available_locales = original_available_locales
  end
end
