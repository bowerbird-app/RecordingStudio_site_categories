# frozen_string_literal: true

module RecordingStudioSiteCategories
  class ApplicationController < (defined?(::ApplicationController) ? ::ApplicationController : ActionController::Base)
    layout "recording_studio_site_categories/blank"

    protect_from_forgery with: :exception
  end
end
