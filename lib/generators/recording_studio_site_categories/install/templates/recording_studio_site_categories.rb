# frozen_string_literal: true

# Optional: wrap the mounted categories index in a host layout.
# nil follows RecordingStudio.configuration.layout, then recording_studio/default_layout.
# RecordingStudioSiteCategories.configure do |config|
#   config.layout = nil
# end

# Register site-level categories here or from addon gems.
RecordingStudioSiteCategories.register_group(
  key: :colour,
  label: "Site colours",
  items: %w[Red Black Blue],
  source: "HostApp"
)
