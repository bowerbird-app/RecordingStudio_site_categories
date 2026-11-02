# frozen_string_literal: true

require_relative "dummy/test/test_helper"

class CategoriesIndexViewTest < ActionView::TestCase
  helper RecordingStudioSiteCategories::ViewHelper

  CategoryGroup = Struct.new(:key, :label, :items)

  setup do
    def view.recording_studio_site_categories_flatpack_component_available?(*)
      false
    end
  end

  test "index template falls back to plain html when flatpack table components are unavailable" do
    @groups = [CategoryGroup.new(:colour, "Site colours", %w[Red Black Blue])]

    html = render(template: "recording_studio_site_categories/categories/index")

    assert_includes html, "Site categories"
    assert_includes html, "Category groups registered at boot for the current host app."
    assert_includes html, "Key"
    assert_includes html, "Label"
    assert_includes html, "Items"
    assert_includes html, "<table"
    assert_includes html, "<th scope=\"col\""
    assert_includes html, "Red, Black, Blue"
    refute_includes html, "translation missing"
  end
end
