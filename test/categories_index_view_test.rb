# frozen_string_literal: true

require "test_helper"
require "ostruct"

class CategoriesIndexViewTest < Minitest::Test
  def test_index_template_falls_back_to_plain_html_when_flatpack_is_absent
    html = without_flatpack do
      view = ActionView::Base.with_empty_template_cache.with_view_paths(
        File.join(__dir__, "..", "app", "views")
      )
      view.extend RecordingStudioSiteCategories::ViewHelper
      view.instance_variable_set(
        :@groups,
        [OpenStruct.new(key: :colour, label: "Site colours", items: %w[Red Black Blue])]
      )

      view.render(template: "recording_studio_site_categories/categories/index")
    end

    assert_includes html, "Site categories"
    assert_includes html, "Category groups registered at boot for the current host app."
    assert_includes html, "<table"
    assert_includes html, "<th scope=\"col\""
    assert_includes html, "Red, Black, Blue"
  end

  private

  def without_flatpack
    previous_flat_pack = Object.const_get(:FlatPack) if Object.const_defined?(:FlatPack, false)
    Object.send(:remove_const, :FlatPack) if previous_flat_pack

    yield
  ensure
    Object.send(:remove_const, :FlatPack) if Object.const_defined?(:FlatPack, false)
    Object.const_set(:FlatPack, previous_flat_pack) if previous_flat_pack
  end
end
