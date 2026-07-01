class HelpersController < ApplicationController
  def show
    @colour_label = RecordingStudioSiteCategories.label_for(:colour)
    @colour_items = RecordingStudioSiteCategories.values_for(:colour)
    @valid_values = ["Red", "Blue", "Green"]
  end
end