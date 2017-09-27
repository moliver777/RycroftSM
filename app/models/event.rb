class Event < ActiveRecord::Base
  ADULTADVANCED = "ADULT ADVANCED"
  ADULTBEGINNER = "ADULT BEGINNER"
  ADULTCAMP = "ADULT CAMP"
  ADULTINTERMEDIATE = "ADULT INTERMEDIATE"
  ADULTNOVICE = "ADULT NOVICE"
  ASSESSMENT = "ASSESSMENT"
  BHS1 = "STAGE 1"
  BHS2 = "STAGE 2"
  BHS3 = "STAGE 3"
  BHS4 = "STAGE 4"
  PTT = "PTT"
  BIRTHDAYPARTY = "BIRTHDAY PARTY"
  CLIENTSDRESSAGE = "CLIENTS DRESSAGE"
  CLIENTSSHOWJUMPING = "CLIENTS SHOW JUMPING"
  CROSSCOUNTRY = "CROSS COUNTRY"
  GROUP = "GROUP LESSON"
  GROUPHACK = "GROUP HACK"
  HOURSOFF = "HOURS OFF"
  INTROBLOCKLESSON = "INTRO BLOCK LESSON"
  INTRODUCTORY = "INTRODUCTORY"
  KIDSBRADOON = "KIDS BRADOON"
  KIDSCAMP = "KIDS CAMP"
  KIDSFULMER = "KIDS FULMER"
  KIDSKIMBERWICKE = "KIDS KIMBERWICKE"
  KIDSMULLEN = "KIDS MULLEN"
  KIDSPELHAM = "KIDS PELHAM"
  KIDSTOTS = "KIDS TOTS"
  KIDSSNAFFLE = "KIDS SNAFFLE"
  KIDSWATERFORD = "KIDS WATERFORD"
  KIDSWEYMOUTH = "KIDS WEYMOUTH"
  LECTURE = "LECTURE"
  LUCKLEYHOUSESCHOOL = "LUCKLEY HOUSE SCHOOL"
  LUNGING = "LUNGING"
  OWNAPONYDAY = "OWN A PONY DAY"
  OWNERSHACK = "OWNERS HACK"
  PRIVATE = "PRIVATE"
  RAF = "RAF"
  SCHOOLING = "SCHOOLING"
  SEMIPRIVATE = "SEMI-PRIVATE"
  STNEOTSSCHOOL = "ST NEOTS SCHOOL"
  STAFF = "STAFF"
  TAKEBACKTHEREINS = "TAKE BACK THE REINS"
  TWESELDOWNHACK = "TWESELDOWN HACK"
  WALKOUT = "WALKOUT"
  
  TYPES = [ADULTADVANCED,ADULTBEGINNER,ADULTCAMP,ADULTINTERMEDIATE,ADULTNOVICE,ASSESSMENT,BHS1,BHS2,BHS3,BHS4,PTT,BIRTHDAYPARTY,CLIENTSDRESSAGE,CLIENTSSHOWJUMPING,CROSSCOUNTRY,GROUP,GROUPHACK,HOURSOFF,INTROBLOCKLESSON,INTRODUCTORY,KIDSBRADOON,KIDSCAMP,KIDSFULMER,KIDSKIMBERWICKE,KIDSMULLEN,KIDSPELHAM,KIDSTOTS,KIDSSNAFFLE,KIDSWATERFORD,KIDSWEYMOUTH,LECTURE,LUCKLEYHOUSESCHOOL,LUNGING,OWNAPONYDAY,OWNERSHACK,PRIVATE,RAF,SCHOOLING,SEMIPRIVATE,STNEOTSSCHOOL,STAFF,TAKEBACKTHEREINS,TWESELDOWNHACK,WALKOUT]
  GROUP_TYPES = [GROUP,GROUPHACK]
  BHS_TYPES = [BHS1,BHS2,BHS3,BHS4,PTT]
  HORSE = [ADULTADVANCED,ADULTBEGINNER,ADULTCAMP,ADULTINTERMEDIATE,ADULTNOVICE,ASSESSMENT,BHS1,BHS2,BHS3,BHS4,PTT,BIRTHDAYPARTY,CLIENTSDRESSAGE,CLIENTSSHOWJUMPING,CROSSCOUNTRY,GROUP,GROUPHACK,INTROBLOCKLESSON,INTRODUCTORY,KIDSBRADOON,KIDSCAMP,KIDSFULMER,KIDSKIMBERWICKE,KIDSMULLEN,KIDSPELHAM,KIDSTOTS,KIDSSNAFFLE,KIDSWATERFORD,KIDSWEYMOUTH,LUCKLEYHOUSESCHOOL,LUNGING,OWNAPONYDAY,OWNERSHACK,PRIVATE,RAF,SCHOOLING,SEMIPRIVATE,STNEOTSSCHOOL,STAFF,TAKEBACKTHEREINS,TWESELDOWNHACK,WALKOUT]
  NO_HORSE = [HOURSOFF,LECTURE]

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
    self.staff_notes = fields[:staff_notes] rescue ""
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

  def payment_duration
    return "N/A" unless self.start_time && self.end_time
    duration = self.end_time-self.start_time
    hours = (duration/3600).to_i
    mins = (duration/60 - hours*60).to_i
    result = ""
    if hours > 0
      result += hours.to_s
      result += hours > 1 ? " hours" : " hour"
      result += " " if mins > 0
    end
    result += mins.to_s+" mins" if mins > 0
    result
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
  
  def get_non_inclusive_splits
    splits = []
    hour = self.start_time.strftime("%H").to_i
    mins = self.start_time.strftime("%M").to_i
    time = (hour < 10 ? "0#{hour}" : "#{hour}")+":"+(mins == 0 ? "00" : "#{mins}")
    while time != self.end_time.strftime("%H:%M")
      splits << time
      mins += 15
      mins = 0 if mins == 60
      hour += 1 if mins == 0
      new_hour = hour < 10 ? "0#{hour}" : "#{hour}"
      new_mins = mins == 0 ? "00" : "#{mins}"
      time = new_hour+":"+new_mins
    end
    splits
  end

  def self.get_splits_times start_time, end_time
    splits = [start_time.strftime("%H:%M")]
    hour = start_time.strftime("%H").to_i
    mins = start_time.strftime("%M").to_i
    time = nil
    while time != end_time.strftime("%H:%M")
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
    Event.where(:event_date => Date.today, :cancelled => false).each do |event|
      issues << {:link => "/bookings/edit_event/"+event.id.to_s, :text => "Event today at "+event.start_time.strftime("%l:%M%P")+" has no instructor assigned to it"} if !event.staff
    end
    issues.uniq
  end
end