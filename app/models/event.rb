class Event < ActiveRecord::Base
  attr_accessible :name, :schedule_yaml

  has_many :occurrences, :class_name => "EventOccurrence"

  include Schedulable

  after_initialize { self.time_zone = "London" }
  before_save { self.schedule_yaml = schedule.to_yaml }

  def occurrences_in_calendar(date_in_month = Date.today)
    sched_occs = schedule.occurrences_between(
      date_in_month.beginning_of_month.beginning_of_week(:sunday),
      date_in_month.end_of_month.end_of_week(:sunday))

    occurrences = sched_occs.map do |sched_occ|
      occurrence = self.occurrences.find_by_start_date(sched_occ.start_time.to_date)
      occurrence ||= EventOccurrence.from_schedule_occurrence(sched_occ)
    end
    occurrences
  end
end
