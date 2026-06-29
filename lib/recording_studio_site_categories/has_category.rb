# frozen_string_literal: true

module RecordingStudioSiteCategories
  module HasCategory
    def self.for(group_key, attribute: group_key)
      Module.new do
        define_method :site_category_group_key do
          group_key
        end

        define_singleton_method :included do |base|
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
