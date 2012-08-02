class Note < ActiveRecord::Base
  GENERAL = "GENERAL"
  BOOKING = "BOOKING"
  CLIENT = "CLIENT"
  HORSE = "HORSE"
  STAFF = "STAFF"
  CATEGORIES = [GENERAL,BOOKING,CLIENT,HORSE,STAFF]

  belongs_to :booking
  belongs_to :client
  belongs_to :horse
  belongs_to :staff

  def set_fields fields
    self.title = fields[:title]
    self.content = fields[:content]
    self.urgent = fields[:urgent] == "true" ? true : false
    self.category = fields[:category]
    case self.category
    when BOOKING
      self.booking_id = fields[:booking_id]
    when CLIENT
      self.client_id = fields[:client_id]
    when HORSE
      self.horse_id = fields[:horse_id]
    when STAFF
      self.staff_id = fields[:staff_id]
    end

    self.save!
  end

  def subject_title
    case self.category
    when "GENERAL"
      title = ""
    when "BOOKING"
      title = self.booking.event.name+" : "+self.booking.client.first_name+" "+self.booking.client.last_name
    when "CLIENT"
      title = self.client.first_name+" "+self.client.last_name
    when "HORSE"
      title = self.horse.name
    when "STAFF"
      title = self.staff.first_name+" "+self.staff.last_name
    end
    title
  end

  def subject_link
    case self.category
    when "GENERAL"
      link = ""
    when "BOOKING"
      link = "/bookings/show/"+self.booking.id.to_s
    when "CLIENT"
      link = "/clients/show/"+self.client.id.to_s
    when "HORSE"
      link = "/horses/show/"+self.horse.id.to_s
    when "STAFF"
      link = "/staff/show/"+self.staff.id.to_s
    end
    link
  end

  def self.priority
    
  end
end