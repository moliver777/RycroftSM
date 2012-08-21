class Event < ActiveRecord::Base
  BEGINNER = "BEGINNER"
  INTERMEDIATE = "INTERMEDIATE"
  ADVANCED = "ADVANCED"
  STANDARDS = [BEGINNER,INTERMEDIATE,ADVANCED]

  PRIVATE = "PRIVATE"
  GROUP = "GROUP"
  INTRODUCTORY = "INTRODUCTORY"
  TYPES = [PRIVATE,GROUP,INTRODUCTORY]

  has_many :bookings
  has_many :clients, :through => :bookings
  has_many :horses, :through => :bookings
  belongs_to :staff
  belongs_to :venue

  def set_fields fields
    staff = Staff.where(:id => fields[:staff_id]).first

    self.name = fields[:name]
    self.description = fields[:description]
    self.event_type = fields[:event_type]
    self.standard = fields[:standard]
    self.venue_id = fields[:venue_id]
    self.event_date = fields[:event_date]
    self.start_time = fields[:start_time]
    self.end_time = fields[:end_time]
    self.max_clients = fields[:max_clients]
    self.staff_id = staff ? staff.id : nil

    self.save!
  end

  def capacity
    self.bookings.count.to_s+"/"+self.max_clients.to_s rescue nil
  end

  def duration
    return "0:00" unless self.start_time && self.end_time
    duration = self.end_time-self.start_time
    hours = (duration/3600).to_i
    mins = (duration/60 - hours*60).to_i
    hours.to_s+":"+(mins == 0 ? "00" : mins.to_s)
  end

  def duration_mins
    return 0 unless self.start_time && self.end_time
    duration = self.end_time-self.start_time
    (duration/60).to_i
  end

  def segment_duration
    return 0 unless self.start_time && self.end_time
    duration = self.end_time-self.start_time
    ((duration/60)/15).to_i
  end

  def client_list
    return "N/A" unless self.clients.first
    self.clients.map{|c| c.first_name+" "+c.last_name}.join(", ") rescue ""
  end

  def horse_list
    return "N/A" unless self.horses.first
    self.horses.map{|c| c.name}.join(", ") rescue ""
  end

  def self.status
    issues = []
    Event.where(:event_date => Date.today).each do |event|
      issues << {:link => "/bookings/edit_event/"+event.id.to_s, :text => event.name+" at "+event.start_time.strftime("%H:%M")+" is over capacity with too many bookings: "+event.bookings.count.to_s+"/"+event.max_clients.to_s} if event.bookings.count > event.max_clients
      issues << {:link => "/bookings/edit_event/"+event.id.to_s, :text => event.name+" at "+event.start_time.strftime("%H:%M")+" has no staff member assigned to it"} if !event.staff
    end
    issues.uniq
  end
end