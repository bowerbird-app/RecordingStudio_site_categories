# frozen_string_literal: true

RecordingStudioSiteCategories.register_group(
  key: :colour,
  label: "Site colours",
  items: ["Red", "Black", "Blue"],
  source: "DummyApp"
)

RecordingStudioSiteCategories.register_group(
  key: :publication_type,
  label: "Publication types",
  items: ["Magazine", "Newspaper", "Journal", "Blog", "Newsletter", "Report"],
  source: "DummyApp"
)

RecordingStudioSiteCategories.register_group(
  key: :long_list,
  label: "A wrapping list of long category names for narrow screens",
  items: [
    "First-run catalogue reprint",
    "Second-run collector edition",
    "Third-run international paperback",
    "Archive restoration master",
    "Limited tour companion booklet"
  ],
  source: "DummyApp"
)
