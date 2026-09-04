# frozen_string_literal: true

require "test_helper"

class CategoriesIndexViewTest < Minitest::Test
  CategoryGroup = Struct.new(:key, :label, :items)

  def test_index_template_falls_back_to_plain_html_when_flatpack_is_absent
    html = without_flatpack do
      view = ActionView::Base.with_empty_template_cache.with_view_paths(
        File.join(__dir__, "..", "app", "views")
      )
      view.extend RecordingStudioSiteCategories::ViewHelper
      view.instance_variable_set(
        :@groups,
        [CategoryGroup.new(:colour, "Site colours", %w[Red Black Blue])]
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

    stub_page_nav_component
    yield
  ensure
    Object.send(:remove_const, :FlatPack) if Object.const_defined?(:FlatPack, false)
    Object.const_set(:FlatPack, previous_flat_pack) if previous_flat_pack
  end

  def stub_page_nav_component
    page_nav = Module.new
    page_nav.const_set(:Component, Class.new do
      def initialize(**_); end

      def render_in(_view_context)
        ""
      end
    end)
    flat_pack = Module.new
    flat_pack.const_set(:PageNav, page_nav)
    Object.const_set(:FlatPack, flat_pack)
  end
end
