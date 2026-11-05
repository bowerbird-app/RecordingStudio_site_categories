# frozen_string_literal: true

module RecordingStudioSiteCategories
  class ApplicationController < (defined?(::ApplicationController) ? ::ApplicationController : ActionController::Base)
    include RecordingStudio::ControllerLayout

    protect_from_forgery with: :exception

    recording_studio_layout { RecordingStudioSiteCategories.configuration.layout }
  end
end
