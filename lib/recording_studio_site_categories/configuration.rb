# frozen_string_literal: true

require "recording_studio/layout"

module RecordingStudioSiteCategories
  class Configuration
    attr_reader :layout

    def initialize
      @layout = nil
    end

    def layout=(value)
      @layout = RecordingStudio::Layout.accept(value)
    end
  end
end
