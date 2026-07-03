# frozen_string_literal: true

require "test_helper"

class RegistryTest < Minitest::Test
  def setup
    @registry = RecordingStudioSiteCategories::Registry.new
  end

  def test_registers_and_fetches_group_details
    @registry.register(key: :colour, label: "Site colours", items: %w[Red Blue], source: "Test")

    assert_equal "Site colours", @registry.label_for(:colour)
    assert_equal %w[Red Blue], @registry.values_for(:colour)
    assert_equal [:colour], @registry.keys
    assert @registry.valid?(:colour, "Red")
    refute @registry.valid?(:colour, "Green")
  end

  def test_clear_removes_registered_groups
    @registry.register(key: :colour, label: "Site colours", items: %w[Red])

    @registry.clear!

    assert_empty @registry.keys
    assert_raises(RecordingStudioSiteCategories::UnknownGroupError) { @registry.group(:colour) }
  end

  def test_unknown_group_raises_custom_error
    error = assert_raises(RecordingStudioSiteCategories::UnknownGroupError) do
      @registry.group(:missing)
    end

    assert_equal "Unknown site category group :missing", error.message
  end

  def test_register_is_thread_safe_for_unique_groups
    threads = 10.times.map do |index|
      Thread.new do
        @registry.register(
          key: "group_#{index}",
          label: "Group #{index}",
          items: ["Value #{index}"],
          source: "Thread#{index}"
        )
      end
    end

    threads.each(&:join)

    assert_equal 10, @registry.keys.size
    assert_equal "Group 4", @registry.label_for(:group_4)
  end
end
