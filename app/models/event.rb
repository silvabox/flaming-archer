class Event < ActiveRecord::Base
  attr_accessible :name, :schedule_yaml

  has_many :occurrences, :class_name => "EventOccurrence"
  has_and_belongs_to_many :participants

  include Schedulable

  after_initialize { self.time_zone = "London" }
  before_save { self.schedule_yaml = schedule.to_yaml }

  def occurrences_in_calendar_page(date_in_page = Date.today)
    occurrences_between(
      date_in_page.beginning_of_month.beginning_of_week(:sunday),
      date_in_page.end_of_month.end_of_week(:sunday))
  end

  def occurrences_between(start, _end = Time.now, save = false)
    # get all persisted occurrences and new instances for scheduled occurrences not already persisted
    schedule_occurrences = schedule.occurrences_between(start, _end)
    occurrences = self.occurrences.between(start, _end)

    # reject all schedule occurrences that are already in persisted occurrences
    schedule_occurrences.reject! do |sched_occ|
      occurrences.any? { |occ| true if sched_occ.start_time == occ.start }
    end

    # create all occurrences that are not already in occurrences
    schedule_occurrences.each do |sched_occ|
      occ = self.occurrences.from_schedule_occurrence(sched_occ)
      occ.save if save
      occurrences << occ
    end
    occurrences.sort!
  end


  def open_occurrences_up_to(_end = Time.now)
      occurrences = occurrences_between(self.schedule.start_time, _end, true)

      # reject all occurrences that are not open
      occurrences.reject! { |occ| occ.status != 'open' } 

      # move the event schedule start_date to the last created event
      self.from_date = occurrences.last.start.to_date if occurrences.last
      occurrences
  end

  def find_or_new_occurrence_by_schedule_occurrence(schedule_occurrence)
      occurrence = self.occurrences.find_by_start(schedule_occurrence.start_time)
      occurrence ||= EventOccurrence.from_schedule_occurrence(schedule_occurrence)
  end

  def find_or_new_occurrence_by_start(start)
    # the - 1 in the following statement is necessary as IceCube looks for the next by adding 1 to the argument
    # the start date must be converted to local time as this IceCube creates a local time using the hour min and seconds
    # but without taking into account the time zone.
    sched_occ = self.schedule.next_occurrence(start.getlocal - 1)
    find_or_new_occurrence_by_schedule_occurrence(sched_occ)
  end

  def grouped_participants
    expected = self.participants.all
    all = Participant.all
    expected = all.dup if expected.empty?
    all.reject! { |participant| expected.include?(participant) }
    { expected: expected, other: all }
  end

  class << self

    def all_open_occurrences_up_to(_end = Time.now)
      events = Event.all

      occurrences = []
      events.each do |event|
        occurrences.concat event.open_occurrences_up_to(_end)
      end
      occurrences.sort
    end
  end

end