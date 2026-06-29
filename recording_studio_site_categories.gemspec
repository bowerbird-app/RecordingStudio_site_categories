# frozen_string_literal: true

require_relative "lib/recording_studio_site_categories/version"

Gem::Specification.new do |spec|
  spec.name        = "recording_studio_site_categories"
  spec.version     = RecordingStudioSiteCategories::VERSION
  spec.authors     = ["Bowerbird"]
  spec.homepage    = "https://github.com/bowerbird-app/RecordingStudio_site_categories"
  spec.summary     = "Site-level category registry for Rails engines"
  spec.description = "Provides an in-memory registry for site category groups, model validation concerns, and FlatPack helpers without a runtime RecordingStudio dependency."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bowerbird-app/RecordingStudio_site_categories"
  spec.metadata["changelog_uri"] = "https://github.com/bowerbird-app/RecordingStudio_site_categories/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.0"
end
