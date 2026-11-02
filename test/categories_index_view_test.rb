# frozen_string_literal: true

require "test_helper"

class CategoriesIndexViewTest < Minitest::Test
  HelperHost = Class.new do
    include RecordingStudioSiteCategories::ViewHelper
  end

  def test_index_flatpack_components_are_unavailable_without_the_gem
    refute defined?(::FlatPack)

    helper = HelperHost.new
    refute helper.recording_studio_site_categories_flatpack_component_available?(
      "FlatPack::PageTitle::Component",
      "FlatPack::Card::Component",
      "FlatPack::Table::Component"
    )
    refute helper.recording_studio_site_categories_flatpack_component_available?(
      "FlatPack::PageNav::Component"
    )
  end
end
