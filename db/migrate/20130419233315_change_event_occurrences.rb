class ChangeEventOccurrences < ActiveRecord::Migration
  def up
    rename_column :event_occurrences, :start_date, :start
    rename_column :event_occurrences, :end_date, :end
  end

  def down
    rename_column :event_occurrences, :start, :start_date
    rename_column :event_occurrences, :end, :end_date
  end
end
