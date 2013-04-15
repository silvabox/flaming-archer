class RenameScheduleToScheduleYamlInEvent < ActiveRecord::Migration
  def up
    rename_column :events, :schedule, :schedule_yaml
  end

  def down
    rename_column :events, :schedule_yaml, :schedule
  end
end
