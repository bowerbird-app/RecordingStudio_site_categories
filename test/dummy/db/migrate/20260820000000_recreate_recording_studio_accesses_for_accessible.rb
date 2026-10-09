# frozen_string_literal: true

# Accessible owns access tables after core removed them in
# 20260421000000_remove_access_control_and_device_sessions. The generator skips
# create_recording_studio_accesses because an older migration with that name
# already exists, so recreate the table here before Accessible's later upgrades.
class RecreateRecordingStudioAccessesForAccessible < ActiveRecord::Migration[8.1]
  def change
    create_table :recording_studio_accesses, id: :uuid do |t|
      t.string :actor_type, null: false
      t.uuid :actor_id, null: false
      t.integer :role, null: false, default: 0

      t.datetime :created_at, null: false
    end

    add_index :recording_studio_accesses, %i[actor_type actor_id],
              name: "index_recording_studio_accesses_on_actor"
    add_index :recording_studio_accesses, %i[actor_type actor_id role],
              name: "index_recording_studio_accesses_on_actor_and_role"
  end
end
