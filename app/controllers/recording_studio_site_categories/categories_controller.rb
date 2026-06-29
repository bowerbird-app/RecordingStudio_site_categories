# frozen_string_literal: true

module RecordingStudioSiteCategories
  class CategoriesController < ApplicationController
    def index
      @groups = RecordingStudioSiteCategories.group_keys.sort.map do |key|
        RecordingStudioSiteCategories.group(key)
      end
    end
  end
end
