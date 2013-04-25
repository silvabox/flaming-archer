class ChangeDateToDateTimeInEventOccurrences < ActiveRecord::Migration
  def up
    change_column :event_occurrences, :start, :datetime
    change_column :event_occurrences, :end, :datetime
  end

  def down
    change_column :event_occurrences, :start, :date
    change_column :event_occurrences, :end, :date
  end
end
