# frozen_string_literal: true

RecordingStudioAccessible.configure do |config|
  # New grants fail closed until polymorphic actor types are listed (Accessible 0.5+).
  config.access_actor_types = [ "User" ]
end
