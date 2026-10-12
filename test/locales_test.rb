# frozen_string_literal: true

require "test_helper"
require "yaml"

class LocalesTest < Minitest::Test
  INDEX_KEYS = {
    "title" => "Site categories",
    "subtitle" => "Category groups registered at boot for the current host app.",
    "columns" => {
      "key" => "Key",
      "label" => "Label",
      "items" => "Items"
    }
  }.freeze

  LAYOUT_KEYS = {
    "application_name" => "RecordingStudio Site Categories"
  }.freeze

  # rubocop:disable Style/FormatStringToken
  SELECT_KEYS = {
    "placeholder" => "Select %{label}"
  }.freeze

  ERROR_KEYS = {
    "not_a_valid" => "is not a valid %{label}",
    "contains_invalid_values" => "contains invalid values: %{values}"
  }.freeze
  # rubocop:enable Style/FormatStringToken

  def setup
    @original_load_path = I18n.load_path.dup
    @original_backend = I18n.backend
    @original_locale = I18n.locale
    @original_available_locales = I18n.available_locales.dup
    I18n.backend = I18n::Backend::Simple.new
    load_engine_locales!
  end

  def teardown
    I18n.load_path = @original_load_path
    I18n.backend = @original_backend
    I18n.locale = @original_locale
    I18n.available_locales = @original_available_locales
  end

  def test_engine_ships_only_english_locale_files
    files = Dir[File.join(engine_locales_dir, "*")].map { |path| File.basename(path) }

    assert_equal ["en.yml"], files.sort
  end

  def test_rails_engine_exposes_english_locale_path
    locale_path = File.expand_path(File.join(engine_locales_dir, "en.yml"))
    existent = RecordingStudioSiteCategories::Engine.paths["config/locales"].existent.map do |path|
      File.expand_path(path)
    end

    assert_includes existent, locale_path
  end

  def test_english_interface_keys_resolve_without_missing_translations
    I18n.with_locale(:en) do
      assert_english_index_and_layout_keys
      assert_english_select_and_error_keys
    end
  end

  def test_en_yml_nests_keys_under_recording_studio_site_categories
    tree = locale_tree(File.join(engine_locales_dir, "en.yml"), "en")
           .fetch("recording_studio")
           .fetch("site_categories")

    assert_equal INDEX_KEYS, deep_stringify(tree.fetch("index"))
    assert_equal LAYOUT_KEYS, deep_stringify(tree.fetch("layout"))
    assert_equal SELECT_KEYS, deep_stringify(tree.fetch("select"))
    assert_equal ERROR_KEYS, deep_stringify(tree.fetch("errors"))
  end

  def test_no_legacy_top_level_locale_namespace_is_shipped
    files = Dir[File.join(engine_locales_dir, "*")].map { |path| File.basename(path) }

    refute_includes files, "recording_studio_site_categories.en.yml"
    tree = locale_tree(File.join(engine_locales_dir, "en.yml"), "en")
    refute tree.key?("recording_studio_site_categories")
  end

  def test_lib_does_not_set_i18n_load_path
    Dir[File.expand_path("../lib/**/*.rb", __dir__)].each do |path|
      source = File.read(path)

      refute_includes source, "i18n.load_path", "#{path} must not set i18n.load_path"
      refute_includes source, "I18n.load_path", "#{path} must not set I18n.load_path"
    end
  end

  def test_gemspec_and_dummy_gemfile_do_not_depend_on_internationalization
    gemspec = File.read(File.expand_path("../recording_studio_site_categories.gemspec", __dir__))
    dummy_gemfile = File.read(File.expand_path("dummy/Gemfile", __dir__))

    refute_includes gemspec, "recording_studio_internationalization"
    refute_includes gemspec, "RecordingStudio_Internationalization"
    refute_includes dummy_gemfile, "recording_studio_internationalization"
    refute_includes dummy_gemfile, "RecordingStudio_Internationalization"
  end

  def test_default_english_is_used_when_key_is_missing_in_current_locale
    I18n.available_locales = Array(I18n.available_locales) | %i[en fr]
    I18n.with_locale(:fr) do
      assert_equal(
        "Select Couleurs",
        I18n.t(
          "recording_studio.site_categories.select.placeholder",
          label: "Couleurs",
          default: RecordingStudioSiteCategories::I18nDefaults::SELECT_PLACEHOLDER
        )
      )
      assert_equal(
        "is not a valid Couleurs",
        I18n.t(
          "recording_studio.site_categories.errors.not_a_valid",
          label: "Couleurs",
          default: RecordingStudioSiteCategories::I18nDefaults::NOT_A_VALID
        )
      )
    end
  end

  private

  def assert_english_index_and_layout_keys
    assert_equal "Site categories", I18n.t("recording_studio.site_categories.index.title", raise: true)
    assert_equal(
      "Category groups registered at boot for the current host app.",
      I18n.t("recording_studio.site_categories.index.subtitle", raise: true)
    )
    assert_equal "Key", I18n.t("recording_studio.site_categories.index.columns.key", raise: true)
    assert_equal "Label", I18n.t("recording_studio.site_categories.index.columns.label", raise: true)
    assert_equal "Items", I18n.t("recording_studio.site_categories.index.columns.items", raise: true)
    assert_equal(
      "RecordingStudio Site Categories",
      I18n.t("recording_studio.site_categories.layout.application_name", raise: true)
    )
  end

  def assert_english_select_and_error_keys
    assert_equal(
      "Select Site colours",
      I18n.t(
        "recording_studio.site_categories.select.placeholder",
        label: "Site colours",
        raise: true
      )
    )
    assert_equal(
      "is not a valid Site colours",
      I18n.t(
        "recording_studio.site_categories.errors.not_a_valid",
        label: "Site colours",
        raise: true
      )
    )
    assert_equal(
      "contains invalid values: Green, Yellow",
      I18n.t(
        "recording_studio.site_categories.errors.contains_invalid_values",
        values: "Green, Yellow",
        raise: true
      )
    )
  end

  def engine_locales_dir
    File.expand_path("../config/locales", __dir__)
  end

  def locale_tree(path, locale)
    YAML.safe_load_file(path, aliases: true).fetch(locale)
  end

  def deep_stringify(value)
    case value
    when Hash
      value.each_with_object({}) { |(key, child), result| result[key.to_s] = deep_stringify(child) }
    else
      value
    end
  end

  def load_engine_locales!
    paths = Dir[File.join(engine_locales_dir, "*.yml")].map { |path| File.expand_path(path) }
    I18n.load_path |= paths
    I18n.backend.load_translations
  end
end
