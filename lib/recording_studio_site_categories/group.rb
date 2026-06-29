# frozen_string_literal: true

module RecordingStudioSiteCategories
  class Group
    attr_reader :key, :label, :items, :source

    def initialize(key:, label:, items:, source: nil)
      @key = key.to_s.downcase.to_sym
      @label = label.to_s
      @items = Array(items).map(&:to_s).freeze
      @source = source
    end
  end
end
