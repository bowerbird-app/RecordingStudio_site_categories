# frozen_string_literal: true

require "test_helper"

class PageHasCategoryTest < ActiveSupport::TestCase
  test "page accepts a registered colour and publication type" do
    page = Page.new(title: "On palette", site_colour: "Red", site_publications: ["Journal"])

    assert page.valid?
  end

  test "page rejects a colour outside the registered group" do
    page = Page.new(title: "Off palette", site_colour: "Green")

    refute page.valid?
    assert_includes page.errors[:site_colour], "is not a valid Site colours"
  end

  test "page rejects a publication type outside the registered group" do
    page = Page.new(title: "Off list", site_publications: ["Pamphlet"])

    refute page.valid?
    assert_includes page.errors[:site_publications].join, "contains invalid values"
  end
end
