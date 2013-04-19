class EventOccurrence < ActiveRecord::Base
  attr_accessible :all_day, :end_date, :start_date, :status

  belongs_to :event
end
