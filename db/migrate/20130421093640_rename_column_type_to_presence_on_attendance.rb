class RenameColumnTypeToPresenceOnAttendance < ActiveRecord::Migration
  def up
    rename_column :attendances, :type, :presence
  end

  def down
    rename_column :attendances, :presence, :type
  end
end
