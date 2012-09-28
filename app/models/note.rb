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
    self.start_date = fields[:start_date]
    self.end_date = fields[:end_date]
    self.weekly = fields[:weekly] == "true" ? true : false
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

  def repeat
    note = Note.new
    note.title = self.title
    note.content = self.content
    note.urgent = self.urgent
    note.category = self.category
    note.booking_id = self.booking_id
    note.client_id = self.client_id
    note.horse_id = self.horse_id
    note.staff_id = self.staff_id
    note.start_date = self.start_date.advance(:days => 7)
    note.end_date = self.end_date.advance(:days => 7)
    note.weekly = true
    note.save!
    self.repeated = true
    self.save!
  end

  def subject_title
    case self.category
    when "GENERAL"
      title = ""
    when "BOOKING"
      title = self.booking.event.event_type.downcase.capitalize+" "+self.booking.event.start_time.strftime("%l:%M%P")+" : "+self.booking.client.first_name+" "+self.booking.client.last_name if self.booking
    when "CLIENT"
      title = self.client.first_name+" "+self.client.last_name if self.client
    when "HORSE"
      title = self.horse.name if self.horse
    when "STAFF"
      title = self.staff.first_name+" "+self.staff.last_name if self.staff
    end
    title
  end

  def subject_link
    case self.category
    when "GENERAL"
      link = ""
    when "BOOKING"
      link = "/bookings/show/"+self.booking.id.to_s if self.booking
    when "CLIENT"
      link = "/clients/show/"+self.client.id.to_s if self.client
    when "HORSE"
      link = "/horses/show/"+self.horse.id.to_s if self.horse
    when "STAFF"
      link = "/staff/show/"+self.staff.id.to_s if self.staff
    end
    link
  end

  def self.priority
    Client.all.each do |client|
      if client.events.where("event_date > ?", Date.today.advance(:months => -3)).count == 0 && client.last_reminder < Date.today.advance(:months => -3)
        note = Note.new
        note.title = "Client hasn't visited for 3 months"
        note.content = "This client should be called."
        note.content += " Home: "+client.home_phone if client.home_phone.length > 0
        note.content += " Mobile: "+client.mobile_phone if client.mobile_phone.length > 0
        note.urgent = false
        note.category = "CLIENT"
        note.client_id = client.id
        note.start_date = Date.today
        note.end_date = Date.today.advance(:days => 7)
        note.save!
        client.last_reminder = Date.today
        client.save!
      end
    end
    Note.where("urgent = ? AND start_date <= ? AND end_date >= ? AND hidden = false", true, Date.today, Date.today)
  end

  def self.birthday_notes
    # if its a clients brithday
      # if birthday_note = false
        # create a birthday note showing just today
        # set birthday_note = true
        # save client
      # end
    # else
      # if birthday_note = true
        # set_birthday_note = false
        # save client
      # end
    # end
  end
end