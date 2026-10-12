# frozen_string_literal: true

module RecordingStudioSiteCategories
  module HasCategory
    def self.for(group_key, attribute: group_key, multiple: false)
      Module.new do
        define_method(:site_category_group_key) { group_key }

        define_singleton_method :included do |base|
          if multiple
            HasCategory.define_array_validation(base, group_key, attribute)
          else
            HasCategory.define_inclusion_validation(base, group_key, attribute)
          end
        end
      end
    end

    def self.define_array_validation(base, group_key, attribute)
      base.class_eval do
        validate :"validate_#{attribute}_array"

        define_method :"validate_#{attribute}_array" do
          HasCategory.validate_array_values(self, group_key, attribute)
        end
      end
    end

    def self.define_inclusion_validation(base, group_key, attribute)
      base.class_eval do
        validate :"validate_#{attribute}_inclusion"

        define_method :"validate_#{attribute}_inclusion" do
          HasCategory.validate_inclusion_value(self, group_key, attribute)
        end
      end
    end

    def self.validate_inclusion_value(record, group_key, attribute)
      value = record.public_send(attribute)
      return if value.blank?
      return if RecordingStudioSiteCategories.values_for(group_key).include?(value)

      label = RecordingStudioSiteCategories.label_for(group_key)
      record.errors.add(
        attribute,
        :inclusion,
        message: not_a_valid_message(label),
        value: value
      )
    end

    def self.validate_array_values(record, group_key, attribute)
      values = Array(record.public_send(attribute)).compact
      return if values.empty?

      allowed = RecordingStudioSiteCategories.values_for(group_key)
      invalid = values.reject { |value| allowed.include?(value.to_s) }
      return if invalid.empty?

      message = contains_invalid_values_message(invalid)
      record.errors.add(attribute, message)
    end

    def self.not_a_valid_message(label)
      I18n.t(
        "recording_studio.site_categories.errors.not_a_valid",
        label: label,
        default: I18nDefaults::NOT_A_VALID
      )
    end

    def self.contains_invalid_values_message(invalid)
      I18n.t(
        "recording_studio.site_categories.errors.contains_invalid_values",
        values: invalid.join(", "),
        default: I18nDefaults::CONTAINS_INVALID_VALUES
      )
    end
  end
end
