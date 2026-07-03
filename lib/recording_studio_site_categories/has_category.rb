# frozen_string_literal: true

module RecordingStudioSiteCategories
  module HasCategory
    def self.for(group_key, attribute: group_key, multiple: false)
      Module.new do
        define_method :site_category_group_key do
          group_key
        end

        define_singleton_method :included do |base|
          if multiple
            base.class_eval do
              validate :"validate_#{attribute}_array"

              define_method :"validate_#{attribute}_array" do
                values = Array(send(attribute)).compact
                return if values.empty?

                allowed = RecordingStudioSiteCategories.values_for(group_key)
                invalid = values.reject { |v| allowed.include?(v.to_s) }
                if invalid.any?
                  errors.add(attribute, "contains invalid values: #{invalid.join(', ')}")
                end
              end
            end
          else
            base.class_eval do
              validates attribute,
                        inclusion: {
                          in: ->(_record) { RecordingStudioSiteCategories.values_for(group_key) },
                          allow_blank: true,
                          message: "is not a valid #{RecordingStudioSiteCategories.label_for(group_key)}"
                        }
            end
          end
        end
      end
    end
  end
end
