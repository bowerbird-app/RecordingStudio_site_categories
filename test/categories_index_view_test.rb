# frozen_string_literal: true

require_relative "dummy/test/test_helper"

class CategoriesIndexViewTest < ActionView::TestCase
  helper RecordingStudioSiteCategories::ViewHelper

  CategoryGroup = Struct.new(:key, :label, :items)

  test "index template renders FlatPack table columns and skips the old html fallback" do
    @groups = [CategoryGroup.new(:colour, "Site colours", %w[Red Black Blue])]

    html = render(template: "recording_studio_site_categories/categories/index")

    assert_includes html, "Key"
    assert_includes html, "Label"
    assert_includes html, "Items"
    assert_includes html, "Red, Black, Blue"
    assert_includes html, "--table-border-color"
    refute_includes html, "th scope=\"col\""
    refute_includes html, "anchor_url"
    refute_includes html, "flat-pack-page-nav"
    refute_includes html, "translation missing"
  end
end
