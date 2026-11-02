# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"

module WorkspaceAccessHelpers
  def grant_workspace_admin!(user, workspace)
    root = RecordingStudio.root_recording_for(workspace)
    return root if RecordingStudioAccessible.authorized?(actor: user, recording: root, role: :view)

    result = RecordingStudioAccessible.bootstrap_owner_access!(recording: root, actor: user)
    unless RecordingStudioAccessible.authorized?(actor: user, recording: root, role: :view)
      result = RecordingStudioAccessible.grant_access(
        recording: root,
        actor: user,
        role: :admin,
        manager_actor: user
      )
    end

    unless RecordingStudioAccessible.authorized?(actor: user, recording: root, role: :view)
      raise "Could not grant workspace access: #{result.inspect}"
    end

    root
  end
end

class ActiveSupport::TestCase
  include WorkspaceAccessHelpers
end

class ActionDispatch::IntegrationTest
  include WorkspaceAccessHelpers
end
