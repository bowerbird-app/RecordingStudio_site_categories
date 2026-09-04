# frozen_string_literal: true

require_relative "view_helper/select"

module RecordingStudioSiteCategories
  module ViewHelper
    include SelectMethods

    FALLBACK_SELECT_HTML_ATTRIBUTES = %i[aria class data disabled id multiple required].freeze

    def recording_studio_site_category_label(group_key)
      RecordingStudioSiteCategories.label_for(group_key)
    end

    def recording_studio_site_category_items(group_key)
      RecordingStudioSiteCategories.values_for(group_key)
    end

    def recording_studio_site_category_options(group_key)
      recording_studio_site_category_items(group_key)
    end

    def recording_studio_site_category_valid?(group_key, value)
      RecordingStudioSiteCategories.valid?(group_key, value)
    end

    def recording_studio_site_categories_flatpack_component_available?(*component_names)
      component_names.all? { |component_name| recording_studio_site_categories_constant(component_name) }
    end

    def recording_studio_site_category_select(form, group_key, attribute_name: group_key, **system_args)
      select = category_select_for(form, group_key, attribute_name, system_args)
      component_class = recording_studio_site_categories_constant("FlatPack::Select::Component")
      return render_flatpack_category_select(component_class, select) if component_class

      recording_studio_site_category_fallback_select(select)
    end
  end
end
