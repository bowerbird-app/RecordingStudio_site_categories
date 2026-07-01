# frozen_string_literal: true

module RecordingStudioSiteCategories
  module ViewHelper
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
      attribute_name = attribute_name.to_sym
      multiple = system_args.delete(:multiple) || false
      object = form.object
      label = system_args.delete(:label) || recording_studio_site_category_label(group_key)
      placeholder = system_args.delete(:include_blank) || "Select #{label}"
      error = object&.errors&.[](attribute_name)&.first
      component_class = recording_studio_site_categories_constant("FlatPack::Select::Component")
      name = multiple ? "#{form.object_name}[#{attribute_name}][]" : "#{form.object_name}[#{attribute_name}]"

      if component_class
        render component_class.new(
          name: name,
          options: recording_studio_site_category_options(group_key),
          value: object&.public_send(attribute_name),
          label: label,
          placeholder: placeholder,
          error: error,
          multiple: multiple,
          **system_args
        )
      else
        recording_studio_site_category_fallback_select(
          form,
          attribute_name: attribute_name,
          label: label,
          placeholder: placeholder,
          error: error,
          group_key: group_key,
          multiple: multiple,
          system_args: system_args
        )
      end
    end

    private

    def recording_studio_site_categories_constant(constant_name)
      current = Object

      constant_name.split("::").reject(&:empty?).each do |name|
        return unless current.const_defined?(name, false)

        current = current.const_get(name, false)
      end

      current
    rescue NameError
      nil
    end

    def recording_studio_site_category_fallback_select(form, attribute_name:, label:, placeholder:, error:, group_key:,
                                                       multiple:, system_args:)
      fragments = []

      fragments << form.label(attribute_name, label) if form.respond_to?(:label)
      html_options = recording_studio_site_category_fallback_html_options(system_args)
      html_options[:multiple] = true if multiple
      fragments << form.select(
        attribute_name,
        recording_studio_site_category_options(group_key),
        { include_blank: placeholder },
        html_options
      )
      fragments << content_tag(:p, error, class: "recording-studio-site-categories__error") if error.present?

      safe_join(fragments)
    end

    def recording_studio_site_category_fallback_html_options(system_args)
      system_args.each_with_object({}) do |(key, value), html_options|
        html_options[key] = value if FALLBACK_SELECT_HTML_ATTRIBUTES.include?(key)
      end
    end
  end
end
