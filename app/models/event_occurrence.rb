class EventOccurrence < ActiveRecord::Base
  attr_accessible :status

  after_initialize :set_status, :set_local_time

  extend FriendlyId
  friendly_id :occurrence_slug

  attr_accessible :all_day, :end, :start, :status

  belongs_to :event
  has_many :attendances, :dependent => :destroy, :include => :participant
  has_many :participants, :through => :attendances

  scope :between, lambda { |start, _end| where('start between ? and ?', start, _end) }

  SlugFormat = "%Y%m%d%H%M%Z"

  def occurrence_slug
    start.strftime(SlugFormat)
  end

  def <=>(other)
    return self.start <=> other.start if other
  end

  def set_status
    self.status ||= 'open'
  end

  def set_local_time
    self.start = self.start.getlocal()
  end

  def self.slug_to_time(slug)
    Time.strptime(slug, SlugFormat)
  end

  def self.from_schedule_occurrence(schedule_occurrence)
      EventOccurrence.new(
        :start => schedule_occurrence.start_time,
        :end => schedule_occurrence.end_time)
  end
end
