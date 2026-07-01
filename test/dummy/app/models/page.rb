class Page < ApplicationRecord
  recording_studio_recordable label: "Page", root: false, allowed_parent_types: [ "Workspace", "Folder" ]

  include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colour)
  include RecordingStudioSiteCategories::HasCategory.for(:publication_type, attribute: :site_publications, multiple: true)

  validates :title, presence: true
end
