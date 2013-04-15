class Event < ActiveRecord::Base
  attr_accessible :name, :repeats, :schedule_yaml

  include ScheduleAttributes

  def repeats
    schedule_attributes.repeat > 0
  end

  def repeats=(value)
    @schedule = Schedule.new(@schedule.date) unless value
  end
end
