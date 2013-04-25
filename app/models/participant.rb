class Participant < ActiveRecord::Base
  attr_accessible :email, :name, :phone

  has_many :attendances, :include => :occurrence
  has_many :occurrences, :class_name => "EventOccurrence", :through => :attendances

  has_and_belongs_to_many :events
end
