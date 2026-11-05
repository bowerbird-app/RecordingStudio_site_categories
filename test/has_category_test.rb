# frozen_string_literal: true

require "test_helper"

class HasCategoryTest < Minitest::Test
  def setup
    RecordingStudioSiteCategories.reset!
    RecordingStudioSiteCategories.register_group(
      key: :colour,
      label: "Site colours",
      items: %w[Red Black Blue],
      source: "Test"
    )

    @model_class = Class.new do
      def self.model_name
        @model_name ||= ActiveModel::Name.new(self, nil, "TestModel")
      end

      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colour

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colour)
    end
  end

  def teardown
    RecordingStudioSiteCategories.reset!
  end

  def test_validates_inclusion_for_registered_values
    record = @model_class.new(site_colour: "Red")

    assert record.valid?
  end

  def test_allows_blank_values
    record = @model_class.new(site_colour: "")

    assert record.valid?
  end

  def test_rejects_invalid_values
    record = @model_class.new(site_colour: "Green")

    refute record.valid?
    assert_includes record.errors[:site_colour], "is not a valid Site colours"
  end

  def test_rejects_symbol_values_that_are_not_exact_members
    record = @model_class.new(site_colour: :Red)

    refute record.valid?
    assert_includes record.errors[:site_colour], "is not a valid Site colours"
    assert record.errors.of_kind?(:site_colour, :inclusion)
  end

  def test_inclusion_error_keeps_inclusion_type_and_value
    record = @model_class.new(site_colour: "Green")

    refute record.valid?
    assert_includes record.errors.details[:site_colour], { error: :inclusion, value: "Green" }
    assert record.errors.of_kind?(:site_colour, :inclusion)
    assert record.errors.added?(:site_colour, :inclusion, value: "Green")
  end

  def test_inclusion_allows_array_when_every_element_is_a_member
    record = @model_class.new(site_colour: ["Red"])

    assert record.valid?
  end

  def test_inclusion_rejects_array_when_any_element_is_not_a_member
    value = %w[Red Green]
    record = @model_class.new(site_colour: value)

    refute record.valid?
    assert_equal [{ error: :inclusion, value: value }], record.errors.details[:site_colour]
    assert record.errors.of_kind?(:site_colour, :inclusion)
  end

  def test_inclusion_error_uses_english_default_in_non_english_locale
    with_isolated_i18n_backend do
      I18n.available_locales = %i[en fr]
      I18n.with_locale(:fr) do
        record = @model_class.new(site_colour: "Green")

        refute record.valid?
        assert_includes record.errors[:site_colour], "is not a valid Site colours"
      end
    end
  end

  def test_inclusion_error_follows_translated_locale_string
    with_isolated_i18n_backend do
      I18n.available_locales = %i[en fr]
      I18n.backend.store_translations(
        :fr,
        recording_studio: {
          site_categories: {
            errors: {
              # rubocop:disable Style/FormatStringToken
              not_a_valid: "n'est pas un %{label} valide"
              # rubocop:enable Style/FormatStringToken
            }
          }
        }
      )

      I18n.with_locale(:fr) do
        record = @model_class.new(site_colour: "Green")

        refute record.valid?
        assert_includes record.errors[:site_colour], "n'est pas un Site colours valide"
      end
    end
  end

  def test_exposes_group_key_helper
    record = @model_class.new

    assert_equal :colour, record.site_category_group_key
  end

  def test_multiple_allows_valid_array
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new(site_colours: %w[Red Black])

    assert record.valid?
  end

  def test_multiple_allows_empty_array
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new(site_colours: [])

    assert record.valid?
  end

  def test_multiple_allows_nil
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new(site_colours: nil)

    assert record.valid?
  end

  def test_multiple_rejects_invalid_values
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new(site_colours: %w[Red Green])

    refute record.valid?
    assert_equal "contains invalid values: Green", record.errors[:site_colours].first
  end

  def test_multiple_error_keeps_string_type_from_main
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new(site_colours: %w[Red Green])
    type = "contains invalid values: Green"

    refute record.valid?
    assert_equal [{ error: type }], record.errors.details[:site_colours]
    assert record.errors.of_kind?(:site_colours, type)
    assert record.errors.added?(:site_colours, type)
  end

  def test_multiple_error_details_and_full_messages_follow_non_english_locale
    model = Class.new do
      def self.model_name
        @model_name ||= ActiveModel::Name.new(self, nil, "MultiColourModel")
      end

      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    with_isolated_i18n_backend do
      I18n.available_locales = %i[en fr]
      I18n.backend.store_translations(
        :fr,
        recording_studio: {
          site_categories: {
            errors: {
              # rubocop:disable Style/FormatStringToken
              contains_invalid_values: "contient des valeurs invalides: %{values}"
              # rubocop:enable Style/FormatStringToken
            }
          }
        }
      )

      I18n.with_locale(:fr) do
        record = model.new(site_colours: %w[Green Yellow])
        translated = "contient des valeurs invalides: Green, Yellow"

        refute record.valid?
        assert_equal [{ error: translated }], record.errors.details[:site_colours]
        assert_equal translated, record.errors[:site_colours].first
        assert(record.errors.full_messages.any? { |message| message.include?(translated) })
      end
    end
  end

  def test_multiple_error_uses_english_default_in_non_english_locale
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    with_isolated_i18n_backend do
      I18n.available_locales = %i[en fr]
      I18n.with_locale(:fr) do
        record = model.new(site_colours: %w[Green Yellow])

        refute record.valid?
        assert_equal "contains invalid values: Green, Yellow", record.errors[:site_colours].first
      end
    end
  end

  def test_multiple_rejects_all_invalid_values
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new(site_colours: %w[Green Yellow])

    refute record.valid?
    assert record.errors[:site_colours].first.include?("Green")
    assert record.errors[:site_colours].first.include?("Yellow")
  end

  def test_multiple_exposes_group_key
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new

    assert_equal :colour, record.site_category_group_key
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
