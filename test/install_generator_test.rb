# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "tmpdir"
require "generators/recording_studio_site_categories/install/install_generator"

class InstallGeneratorTest < Minitest::Test
  def with_temp_app
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "config", "initializers"))
      yield dir
    end
  end

  def build_generator(destination_root)
    RecordingStudioSiteCategories::Generators::InstallGenerator.new([], {}, destination_root: destination_root)
  end

  def test_generator_creates_initializer
    with_temp_app do |dir|
      generator = build_generator(dir)

      generator.invoke_all

      initializer_path = File.join(dir, "config", "initializers", "recording_studio_site_categories.rb")
      assert File.exist?(initializer_path)

      initializer = File.read(initializer_path)
      assert_includes initializer, "RecordingStudioSiteCategories.register_group"
      assert_includes initializer, 'key: :colour'
      assert_includes initializer, 'source: "HostApp"'
    end
  end

  def test_generator_prints_post_install_guidance
    generator = build_generator("/tmp")
    messages = []

    generator.stub(:say, ->(message, *_args) { messages << message }) do
      generator.show_post_install_message
    end

    assert_includes messages, "Registered categories belong in config/initializers/recording_studio_site_categories.rb or addon boot code."
    assert_includes messages, "Duplicate group keys raise immediately during boot."
    assert_includes messages, "recording_studio_site_categories does not create any database tables."
  end
end
