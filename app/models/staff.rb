class Staff < ActiveRecord::Base
  has_many :events
  has_many :notes

  def address
    address = ""
    address += self.address_line_1 if self.address_line_1
    address += ", "+self.address_line_2 if self.address_line_2
    address += ", "+self.city if self.city
    address += ", "+self.county if self.county
    address += ", "+self.country if self.country
  end

  def set_fields fields
    self.first_name = fields[:first_name]
    self.last_name = fields[:last_name]
    self.date_of_birth = fields[:date_of_birth]
    self.role = fields[:role]
    self.skip_issues = fields[:skip_issues] == "true" ? true : false

    self.address_line_1 = fields[:address_line_1]
    self.address_line_2 = fields[:address_line_2]
    self.city = fields[:city]
    self.county = fields[:county]
    self.country = fields[:country]
    self.post_code = fields[:post_code]
    self.home_phone = fields[:home_phone]
    self.mobile_phone = fields[:mobile_phone]

    self.monday = fields[:monday] == "true" ? true : false
    self.tuesday = fields[:tuesday] == "true" ? true : false
    self.wednesday = fields[:wednesday] == "true" ? true : false
    self.thursday = fields[:thursday] == "true" ? true : false
    self.friday = fields[:friday] == "true" ? true : false
    self.saturday = fields[:saturday] == "true" ? true : false
    self.sunday = fields[:sunday] == "true" ? true : false

    self.save!
  end

  def available
    available = ""
    available += "Monday, " if self.monday
    available += "Tuesday, " if self.tuesday
    available += "Wednesday, " if self.wednesday
    available += "Thursday, " if self.thursday
    available += "Friday, " if self.friday
    available += "Saturday, " if self.saturday
    available += "Sunday, " if self.sunday
    available.length > 0 ? available[0..-3] : ""
  end

  def is_available day
    result = true
    case day
    when "Mon"
      result = self.monday
    when "Tue"
      result = self.tuesday
    when "Wed"
      result = self.wednesday
    when "Thu"
      result = self.thursday
    when "Fri"
      result = self.friday
    when "Sat"
      result = self.saturday
    when "Sun"
      result = self.sunday
    end
    result
  end

  def workload_period from, to
    hours = 0
    mins = 0
    self.events.where(:event_date => from..to, :cancelled => false).each do |event|
      duration = event.duration.split(":")
      hours += duration[0].to_i
      mins += duration[1].to_i
    end
    hours += mins/60
    mins = mins%60
    mins > 0 ? hours.to_s+"."+((mins/15)*25).to_s : hours.to_s
  end

  def self.status
    issues = []
    Staff.where(:skip_issues => false).each do |staff|
      date = Date.today
      14.times do |i|
        event_splits = []
        staff.all_events(date).each do |event|
          splits = []
          splits << event.start_time.strftime("%H:%M")
          hour = event.start_time.strftime("%H")
          mins = event.start_time.strftime("%M")
          while hour.to_s+":"+mins.to_s != event.end_time.strftime("%H:%M")
            mins = mins.to_i+15
            if mins == 60
              mins = "00"
              hour = hour.to_i+1
              hour = "0"+hour.to_s if hour < 10
            end
            splits << hour.to_s+":"+mins.to_s
          end
          event_splits << splits
        end
        # test for overlap of lessons
        event_splits.each_with_index do |event,i|
          event.each do |split|
            event_splits.each_with_index do |event2,j|
              event2.each do |split2|
                if i != j && split2 != event2.first && split2 != event2.last
                  issues << {:link => "/bookings/date/#{date.strftime("%d-%m-%Y")}", :text => staff.first_name+" "+staff.last_name+" is double-booked "+(date==Date.today ? "today" : "on "+date.strftime("%A #{date.strftime("%e").to_i.ordinalize} %B"))} if split == split2
                end
              end
            end
          end
        end
        date = date.advance(:days => 1)
      end
    end
    issues.uniq
  end

  def all_events date
    Event.where("event_date = ? AND cancelled = ? AND (staff_id = ? OR staff_id2 = ? OR staff_id3 = ?)", date, false, self.id, self.id, self.id)
  end
end