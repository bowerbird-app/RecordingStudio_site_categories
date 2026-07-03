# frozen_string_literal: true

module RecordingStudioSiteCategories
  class Registry
    def initialize
      @groups = {}.freeze
      @mutex = Mutex.new
    end

    def register(key:, label:, items:, source: nil)
      normalized = key.to_s.downcase.to_sym

      @mutex.synchronize do
        if @groups.key?(normalized)
          existing = @groups[normalized]
          owner = existing.source || "unknown"
          raise DuplicateGroupError,
                "Site category group :#{normalized} is already registered by #{owner.inspect}"
        end

        @groups = @groups.merge(
          normalized => Group.new(
            key: normalized,
            label: label,
            items: items,
            source: source
          )
        ).freeze
      end
    end

    def group(key)
      @groups.fetch(key.to_s.downcase.to_sym)
    rescue KeyError
      raise UnknownGroupError, "Unknown site category group :#{key}"
    end

    def label_for(key)
      group(key).label
    end

    def values_for(key)
      group(key).items
    end

    def valid?(key, value)
      values_for(key).include?(value.to_s)
    end

    def keys
      @groups.keys
    end

    def clear!
      @mutex.synchronize do
        @groups = {}.freeze
      end
    end
  end
end
