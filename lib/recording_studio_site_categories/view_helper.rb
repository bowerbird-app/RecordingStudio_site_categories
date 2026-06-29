# frozen_string_literal: true

module RecordingStudioSiteCategories
  module ViewHelper
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

    def recording_studio_site_category_select(form, group_key, attribute_name: group_key, **system_args)
      attribute_name = attribute_name.to_sym
      object = form.object

      render FlatPack::Select::Component.new(
        name: "#{form.object_name}[#{attribute_name}]",
        options: recording_studio_site_category_options(group_key),
        value: object&.public_send(attribute_name),
        label: system_args.delete(:label) || recording_studio_site_category_label(group_key),
        placeholder: system_args.delete(:include_blank) || "Select #{recording_studio_site_category_label(group_key)}",
        error: object&.errors&.[](attribute_name)&.first,
        **system_args
      )
    end
  end
end
