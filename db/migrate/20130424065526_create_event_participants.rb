class CreateEventParticipants < ActiveRecord::Migration
  def change
      create_table :event_participants do |t|
      t.references :event
      t.references :participant

      t.timestamps
    end
  end
end
