# frozen_string_literal: true

require "test_helper"

class DuplicateGroupTest < Minitest::Test
  def test_registering_same_group_key_twice_raises_with_source
    registry = RecordingStudioSiteCategories::Registry.new
    registry.register(key: :colour, label: "Site colours", items: %w[Red], source: "AddonA")

    error = assert_raises(RecordingStudioSiteCategories::DuplicateGroupError) do
      registry.register(key: :colour, label: "Other colours", items: %w[Blue], source: "AddonB")
    end

    assert_equal 'Site category group :colour is already registered by "AddonA"', error.message
  end
end
