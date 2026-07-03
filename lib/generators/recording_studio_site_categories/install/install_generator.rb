# frozen_string_literal: true

require "rails/generators"

module RecordingStudioSiteCategories
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a site categories initializer"

      def copy_initializer
        template "recording_studio_site_categories.rb", "config/initializers/recording_studio_site_categories.rb"
      end

      def show_post_install_message
        say "Registered categories belong in config/initializers/recording_studio_site_categories.rb or addon boot code.", :green
        say "Duplicate group keys raise immediately during boot.", :green
        say "recording_studio_site_categories does not create any database tables.", :green
      end
    end
  end
end
