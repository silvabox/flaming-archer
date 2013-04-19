class EventOccurrence < ActiveRecord::Base
  attr_accessible :all_day, :end_date, :start_date, :status

  belongs_to :event

  def self.from_schedule_occurrence(occurrence)
      EventOccurrence.new(start_date: occurrence.start_time.to_date,
        end_date: occurrence.end_time.to_date,
        status: :open)
  end
end
