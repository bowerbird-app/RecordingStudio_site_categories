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
