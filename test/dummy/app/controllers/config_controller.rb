class ConfigController < ApplicationController
  def show
    @groups = RecordingStudioSiteCategories.group_keys.sort.map do |key|
      RecordingStudioSiteCategories.group(key)
    end
  end
end