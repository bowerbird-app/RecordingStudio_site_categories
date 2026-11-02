class Page < ApplicationRecord
  recording_studio_recordable label: "Page", root: false, allowed_parent_types: [ "Workspace", "Folder" ]
  include RecordingStudio::Capabilities::Trashable.to
  include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colour)
  include RecordingStudioSiteCategories::HasCategory.for(:publication_type, attribute: :site_publications, multiple: true)

  validates :title, presence: true
end
