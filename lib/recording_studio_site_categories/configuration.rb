# frozen_string_literal: true

module RecordingStudioSiteCategories
  class Configuration
    attr_reader :layout

    def initialize
      @layout = nil
    end

    def layout=(value)
      @layout = if defined?(::RecordingStudio::Layout)
        RecordingStudio::Layout.accept(value)
      else
        value
      end
    end
  end
end
