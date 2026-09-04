# frozen_string_literal: true

module RecordingStudioSiteCategories
  module ViewHelper
    module SelectMethods
      CategorySelect = Struct.new(
        :form,
        :group_key,
        :attribute_name,
        :multiple,
        :object,
        :label,
        :placeholder,
        :error,
        :name,
        :system_args,
        keyword_init: true
      )

      private

      def category_select_for(form, group_key, attribute_name, system_args)
        attribute_name = attribute_name.to_sym
        multiple = system_args.delete(:multiple) || false
        CategorySelect.new(**select_fields(form, group_key, attribute_name, multiple, system_args))
      end

      def select_fields(form, group_key, attribute_name, multiple, system_args)
        object = form.object
        label = system_args.delete(:label) || recording_studio_site_category_label(group_key)
        {
          form: form, group_key: group_key, attribute_name: attribute_name, multiple: multiple,
          object: object, label: label, system_args: system_args,
          placeholder: system_args.delete(:include_blank) || "Select #{label}",
          error: first_attribute_error(object, attribute_name),
          name: category_select_name(form, attribute_name, multiple)
        }
      end

      def first_attribute_error(object, attribute_name)
        return unless object.respond_to?(:errors)

        object.errors[attribute_name]&.first
      end

      def category_select_name(form, attribute_name, multiple)
        return "#{form.object_name}[#{attribute_name}][]" if multiple

        "#{form.object_name}[#{attribute_name}]"
      end

      def render_flatpack_category_select(component_class, select)
        render component_class.new(
          name: select.name,
          options: recording_studio_site_category_options(select.group_key),
          value: select.object&.public_send(select.attribute_name),
          label: select.label,
          placeholder: select.placeholder,
          error: select.error,
          multiple: select.multiple,
          **select.system_args
        )
      end

      def recording_studio_site_categories_constant(constant_name)
        names = constant_name.split("::").reject(&:empty?)
        names.reduce(Object) do |current, name|
          break unless current.const_defined?(name, false)

          current.const_get(name, false)
        end
      rescue NameError
        nil
      end

      def recording_studio_site_category_fallback_select(select)
        fragments = [
          fallback_select_label(select),
          fallback_select_tag(select),
          fallback_select_error(select)
        ]
        safe_join(fragments.compact)
      end

      def fallback_select_label(select)
        return unless select.form.respond_to?(:label)

        select.form.label(select.attribute_name, select.label)
      end

      def fallback_select_tag(select)
        html_options = recording_studio_site_category_fallback_html_options(select.system_args)
        html_options[:multiple] = true if select.multiple
        select.form.select(
          select.attribute_name,
          recording_studio_site_category_options(select.group_key),
          { include_blank: select.placeholder },
          html_options
        )
      end

      def fallback_select_error(select)
        return if select.error.blank?

        content_tag(:p, select.error, class: "recording-studio-site-categories__error")
      end

      def recording_studio_site_category_fallback_html_options(system_args)
        system_args.each_with_object({}) do |(key, value), html_options|
          html_options[key] = value if FALLBACK_SELECT_HTML_ATTRIBUTES.include?(key)
        end
      end
    end
  end
end
