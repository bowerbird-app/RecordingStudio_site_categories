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
        validates attribute,
                  inclusion: {
                    in: ->(_record) { RecordingStudioSiteCategories.values_for(group_key) },
                    allow_blank: true,
                    message: "is not a valid #{RecordingStudioSiteCategories.label_for(group_key)}"
                  }
      end
    end

    def self.validate_array_values(record, group_key, attribute)
      values = Array(record.public_send(attribute)).compact
      return if values.empty?

      allowed = RecordingStudioSiteCategories.values_for(group_key)
      invalid = values.reject { |value| allowed.include?(value.to_s) }
      return if invalid.empty?

      record.errors.add(attribute, "contains invalid values: #{invalid.join(', ')}")
    end
  end
end
