# frozen_string_literal: true

require "recording_studio_site_categories/version"
require "recording_studio_site_categories/errors"
require "recording_studio_site_categories/group"
require "recording_studio_site_categories/registry"
require "recording_studio_site_categories/has_category"
require "recording_studio_site_categories/view_helper"
require "recording_studio_site_categories/engine"

module RecordingStudioSiteCategories
  class << self
    def registry
      @registry ||= Registry.new
    end

    def register_group(key:, label:, items:, source: nil)
      registry.register(key: key, label: label, items: items, source: source)
    end

    def group(key)
      registry.group(key)
    end

    def label_for(key)
      registry.label_for(key)
    end

    def values_for(key)
      registry.values_for(key)
    end

    def valid?(key, value)
      registry.valid?(key, value)
    end

    def group_keys
      registry.keys
    end

    def reset!
      registry.clear!
    end
  end
end
