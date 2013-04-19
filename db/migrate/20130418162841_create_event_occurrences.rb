class CreateEventOccurrences < ActiveRecord::Migration
  def change
    create_table :event_occurrences do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :all_day
      t.string :status
      t.references :event

      t.timestamps
    end
  end
end
