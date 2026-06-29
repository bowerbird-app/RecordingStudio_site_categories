# frozen_string_literal: true

module RecordingStudioSiteCategories
  class Engine < ::Rails::Engine
    isolate_namespace RecordingStudioSiteCategories

    initializer "recording_studio_site_categories.view_helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper RecordingStudioSiteCategories::ViewHelper
      end
    end
  end
end
