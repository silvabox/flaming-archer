class RemoveTimestampsFromEventsParticipants < ActiveRecord::Migration
  def up
    remove_column :events_participants, :created_at
    remove_column :events_participants, :updated_at
  end

  def down
    add_column :events_participants, :created_at, :datetime
    add_column :events_participants, :updated_at, :datetime
  end
end
