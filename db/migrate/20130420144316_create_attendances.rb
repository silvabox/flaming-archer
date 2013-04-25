class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.string :type
      t.references :event_occurrence
      t.references :participant

      t.timestamps
    end
    add_index :attendances, :event_occurrence_id
    add_index :attendances, :participant_id
  end
end
