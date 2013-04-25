class Attendance < ActiveRecord::Base
  belongs_to :event_occurrence
  belongs_to :participant
  attr_accessible :presence
end
