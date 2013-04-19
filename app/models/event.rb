class Event < ActiveRecord::Base
  attr_accessible :name, :schedule_yaml

  has_many :occurrences, :class_name => "EventOccurrence"

  include Schedulable

  after_initialize { self.time_zone = "London" }
  before_save { self.schedule_yaml = schedule.to_yaml }

  def occurrences_in_calendar(date_in_month = Date.today)
    sched_occs = schedule.occurrences_between(
      date_in_month.beginning_of_month.beginning_of_week,
      date_in_month.end_of_month.end_of_week)

    occurrences = sched_occs.map do |occ|
      self.occurrences.find_or_create_by_start_date(occ.start_time)
    end
    occurrences
  end
end
