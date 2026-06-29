# frozen_string_literal: true

require "test_helper"

class EngineTest < Minitest::Test
  def test_engine_routes_categories_root
    route = RecordingStudioSiteCategories::Engine.routes.recognize_path("/", method: :get)

    assert_equal "recording_studio_site_categories/categories", route[:controller]
    assert_equal "index", route[:action]
  end

  def test_view_helper_initializer_registers_helper_on_action_controller_base
    on_load_calls = []
    helper_calls = []
    controller_base = Class.new do
      define_singleton_method(:helper) do |helper_module|
        helper_calls << helper_module
      end
    end

    initializer = RecordingStudioSiteCategories::Engine.initializers.find do |candidate|
      candidate.name == "recording_studio_site_categories.view_helpers"
    end

    ActiveSupport.stub(:on_load, ->(hook_name, &block) { on_load_calls << [hook_name, block] }) do
      initializer.block.call
    end

    assert_equal :action_controller_base, on_load_calls.first.first
    controller_base.instance_exec(&on_load_calls.first.last)
    assert_equal [RecordingStudioSiteCategories::ViewHelper], helper_calls
  end
end
