# frozen_string_literal: true

require "test_helper"
require "devise/test/integration_helpers"

class SiteCategoriesI18nTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  HOST_OVERRIDE_LOCALE = File.expand_path(
    "../locales/site_categories_host_override.en.yml",
    __dir__
  ).freeze

  setup do
    @user = User.find_or_create_by!(email: "site-categories-i18n@example.com") do |user|
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end
    @original_load_path = I18n.load_path.dup
    @original_locale = I18n.locale
    @original_available_locales = I18n.available_locales.dup
    I18n.available_locales = Array(I18n.available_locales) | %i[en fr]
    sign_in @user
  end

  teardown do
    I18n.load_path = @original_load_path
    I18n.locale = @original_locale
    I18n.available_locales = @original_available_locales
    I18n.reload!
  end

  test "mounted categories page renders gem English interface text" do
    get "/recording_studio_site_categories"

    assert_response :success
    assert_includes response.body, "Site categories"
    assert_includes response.body, "Category groups registered at boot for the current host app."
    assert_includes response.body, "RecordingStudio Site Categories"
    refute_includes response.body, "HOST Site categories"
    refute_includes response.body, "translation missing"
  end

  test "pages form renders English select placeholder from the gem" do
    get "/pages/new"

    assert_response :success
    assert_includes response.body, "Select Site colours"
    assert_includes response.body, "Select Publication types"
    refute_includes response.body, "HOST Select"
    refute_includes response.body, "translation missing"
  end

  test "helpers page renders English select placeholder from the gem" do
    get "/helpers"

    assert_response :success
    assert_includes response.body, "Select Site colours"
    refute_includes response.body, "HOST Select"
    refute_includes response.body, "translation missing"
  end

  test "host locale fixture overrides gem English on a real page" do
    begin
      I18n.load_path << HOST_OVERRIDE_LOCALE
      I18n.reload!

      get "/recording_studio_site_categories"

      assert_response :success
      assert_includes response.body, "HOST Site categories"
      assert_includes response.body, "HOST Category groups registered at boot for the current host app."
      assert_includes response.body, "HOST RecordingStudio Site Categories"
      refute_includes response.body, ">Site categories<"
    ensure
      I18n.load_path = @original_load_path.dup
      I18n.reload!
      assert_equal @original_load_path, I18n.load_path
    end
  end

  test "host locale fixture overrides select placeholder on pages form" do
    begin
      I18n.load_path << HOST_OVERRIDE_LOCALE
      I18n.reload!

      get "/pages/new"

      assert_response :success
      assert_includes response.body, "HOST Select Site colours"
      assert_includes response.body, "HOST Select Publication types"
    ensure
      I18n.load_path = @original_load_path.dup
      I18n.reload!
      assert_equal @original_load_path, I18n.load_path
    end
  end

  test "host locale fixture overrides HasCategory validation messages on real validation" do
    begin
      I18n.load_path << HOST_OVERRIDE_LOCALE
      I18n.reload!

      single_model = Class.new do
        def self.model_name
          @model_name ||= ActiveModel::Name.new(self, nil, "HostOverrideColour")
        end

        include ActiveModel::Model
        include ActiveModel::Validations
        attr_accessor :site_colour

        include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colour)
      end

      multiple_model = Class.new do
        def self.model_name
          @model_name ||= ActiveModel::Name.new(self, nil, "HostOverrideColours")
        end

        include ActiveModel::Model
        include ActiveModel::Validations
        attr_accessor :site_colours

        include RecordingStudioSiteCategories::HasCategory.for(
          :colour, attribute: :site_colours, multiple: true
        )
      end

      single = single_model.new(site_colour: "Green")
      refute single.valid?
      assert_includes single.errors[:site_colour], "HOST is not a valid Site colours"
      assert single.errors.of_kind?(:site_colour, :inclusion)

      multiple = multiple_model.new(site_colours: %w[Green Yellow])
      refute multiple.valid?
      assert_equal(
        "HOST contains invalid values: Green, Yellow",
        multiple.errors[:site_colours].first
      )
    ensure
      I18n.load_path = @original_load_path.dup
      I18n.reload!
      assert_equal @original_load_path, I18n.load_path
    end
  end

  test "without the test-only host override gem English still renders" do
    get "/recording_studio_site_categories"

    assert_response :success
    assert_includes response.body, "Site categories"
    refute_includes response.body, "HOST Site categories"
    assert_equal @original_load_path, I18n.load_path
  end

  test "rails i18n load path includes the gem english locale file" do
    locale_path = File.expand_path(
      "../../../../config/locales/en.yml",
      __dir__
    )

    assert_includes I18n.load_path.map { |path| File.expand_path(path) }, File.expand_path(locale_path)
  end

  test "select placeholder follows non-english locale without boot memoization" do
    I18n.backend.store_translations(
      :fr,
      recording_studio: {
        site_categories: {
          select: {
            placeholder: "Choisir %{label}"
          }
        }
      }
    )

    I18n.with_locale(:en) do
      get "/pages/new"

      assert_response :success
      assert_includes response.body, "Select Site colours"
      refute_includes response.body, "Choisir Site colours"
    end

    I18n.with_locale(:fr) do
      get "/pages/new"

      assert_response :success
      assert_includes response.body, "Choisir Site colours"
    end

    I18n.with_locale(:en) do
      get "/pages/new"

      assert_response :success
      assert_includes response.body, "Select Site colours"
      refute_includes response.body, "Choisir Site colours"
    end
  end
end
