class Event < ActiveRecord::Base
  INTRODUCTORY = "INTRODUCTORY"
  WALKOUT = "WALKOUT"
  PRIVATE = "PRIVATE"
  SEMIPRIVATE = "SEMI-PRIVATE"
  GROUP = "GROUP LESSON"
  GROUPHACK = "GROUP HACK"
  BHS1 = "STAGE 1"
  BHS2 = "STAGE 2"
  BHS3 = "STAGE 3"
  BHS4 = "STAGE 4"
  LECTURE = "LECTURE"
  HOURSOFF = "HOURS OFF"
  TYPES = [INTRODUCTORY,WALKOUT,PRIVATE,SEMIPRIVATE,GROUP,GROUPHACK,BHS1,BHS2,BHS3,BHS4,LECTURE,HOURSOFF]
  GROUP_TYPES = [GROUP]
  BHS_TYPES = [BHS1,BHS2,BHS3,BHS4]
  NO_HORSE = [HOURSOFF]

  has_many :bookings
  has_many :clients, :through => :bookings
  has_many :horses, :through => :bookings
  belongs_to :staff
  belongs_to :venue

  def set_fields fields
    staff = Staff.where(:id => fields[:staff_id]).first
    staff2 = Staff.where(:id => fields[:staff_id2]).first
    staff3 = Staff.where(:id => fields[:staff_id3]).first

    self.description = fields[:description] rescue ""
    self.event_type = fields[:event_type]
    self.venue_id = fields[:venue_id]
    self.master_venue_id = fields[:master_venue_id]
    self.event_date = fields[:event_date]
    self.start_time = fields[:start_time]
    self.end_time = fields[:end_time]
    self.staff_id = staff ? staff.id : nil
    self.staff_id2 = staff2 ? staff2.id : nil
    self.staff_id3 = staff3 ? staff3.id : nil

    self.save!
  end

  def rebook old, venue, fields
    self.description = old.description
    self.event_type = old.event_type
    self.venue_id = venue
    self.master_venue_id = old.master_venue_id
    self.event_date = fields[:event_date]
    self.start_time = fields[:start_time]
    self.end_time = fields[:end_time]
    self.staff_id = old.staff_id

    self.save!
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

  def staff_list
    return "N/A" unless self.staff_id || self.staff_id2 || self.staff_id3
    Staff.where("id = ? OR id = ? OR id = ?", self.staff_id, self.staff_id2, self.staff_id3).map{|s| s.first_name+" "+s.last_name}.join(", ") rescue ""
  end

  def get_splits
    splits = [self.start_time.strftime("%H:%M")]
    hour = self.start_time.strftime("%H").to_i
    mins = self.start_time.strftime("%M").to_i
    time = nil
    while time != self.end_time.strftime("%H:%M")
      mins += 15
      mins = 0 if mins == 60
      hour += 1 if mins == 0
      new_hour = hour < 10 ? "0#{hour}" : "#{hour}"
      new_mins = mins == 0 ? "00" : "#{mins}"
      time = new_hour+":"+new_mins
      splits << time
    end
    splits
  end

  def self.status
    issues = []
    Event.where(:event_date => Date.today).each do |event|
      issues << {:link => "/bookings/edit_event/"+event.id.to_s, :text => "Event at "+event.start_time.strftime("%l:%M%P")+" has no instructor assigned to it"} if !event.staff
    end
    issues.uniq
  end
end