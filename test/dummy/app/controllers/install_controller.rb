class InstallController < ApplicationController
  def show
    @erb_usage_code = '<%= recording_studio_site_category_select(form, :colour, attribute_name: :site_colour) %>'
  end
end