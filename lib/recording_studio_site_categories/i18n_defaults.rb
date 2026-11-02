# frozen_string_literal: true

module RecordingStudioSiteCategories
  # English fallbacks for I18n.t(..., default:). Tokens use I18n's %{name} form.
  module I18nDefaults
    SELECT_PLACEHOLDER = "Select %{label}"
    NOT_A_VALID = "is not a valid %{label}"
    CONTAINS_INVALID_VALUES = "contains invalid values: %{values}"
  end
end
