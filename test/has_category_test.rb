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
        @_model_name ||= ActiveModel::Name.new(self, nil, "TestModel")
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

    record = model.new(site_colours: ["Red", "Black"])

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

    record = model.new(site_colours: ["Red", "Green"])

    refute record.valid?
    assert record.errors[:site_colours].first.include?("Green")
  end

  def test_multiple_rejects_all_invalid_values
    model = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :site_colours

      include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colours, multiple: true)
    end

    record = model.new(site_colours: ["Green", "Yellow"])

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
end
