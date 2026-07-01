class HelpersController < ApplicationController
  def show
    @colour_label = RecordingStudioSiteCategories.label_for(:colour)
    @colour_items = RecordingStudioSiteCategories.values_for(:colour)
    @valid_values = ["Red", "Blue", "Green"]
    @demo_page = Page.new
    @select_usage_code = '<%= recording_studio_site_category_select(form, :colour, attribute_name: :site_colour, searchable: true) %>'
    @publication_label = RecordingStudioSiteCategories.label_for(:publication_type)
    @publication_items = RecordingStudioSiteCategories.values_for(:publication_type)
    @publication_options = @publication_items.map { |item| [item, item] }
    @select_multiple_direct_code = '<%= recording_studio_site_category_select(form, :publication_type, attribute_name: :site_publications, searchable: true, multiple: true) %>'
  end
end