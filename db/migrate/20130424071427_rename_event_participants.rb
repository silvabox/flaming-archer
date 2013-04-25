class RenameEventParticipants < ActiveRecord::Migration
  def up
    rename_table :event_participants, :events_participants
  end

  def down
    rename_table :events_participants, :event_participants
  end
end
