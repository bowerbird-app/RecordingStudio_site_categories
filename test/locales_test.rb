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

  def test_engine_ships_only_english_locale_files
    files = Dir[File.join(engine_locales_dir, "*")].map { |path| File.basename(path) }

    assert_equal ["en.yml"], files.sort
  end

  def test_rails_i18n_load_path_includes_the_gem_english_locale_file
    locale_path = File.join(engine_locales_dir, "en.yml")

    assert_includes I18n.load_path.map { |path| File.expand_path(path) }, File.expand_path(locale_path)
  end

  def test_english_interface_keys_resolve_without_missing_translations
    I18n.with_locale(:en) do
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
  end

  def test_en_yml_nests_keys_under_recording_studio_site_categories
    tree = locale_tree(File.join(engine_locales_dir, "en.yml"), "en")
           .fetch("recording_studio")
           .fetch("site_categories")

    assert_equal INDEX_KEYS, deep_stringify(tree.fetch("index"))
    assert_equal LAYOUT_KEYS, deep_stringify(tree.fetch("layout"))
  end

  private

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
end
