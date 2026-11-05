# frozen_string_literal: true

module RecordingStudioSiteCategories
  class ApplicationController < (defined?(::ApplicationController) ? ::ApplicationController : ActionController::Base)
    protect_from_forgery with: :exception

    if defined?(::RecordingStudio::ControllerLayout)
      include RecordingStudio::ControllerLayout

      recording_studio_layout { RecordingStudioSiteCategories.configuration.layout }
    else
      layout "recording_studio_site_categories/blank"
    end
  end
end
