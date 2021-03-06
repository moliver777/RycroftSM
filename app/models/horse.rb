class Horse < ActiveRecord::Base
  has_many :bookings
  has_many :notes
  has_many :events, :through => :bookings

  def set_fields fields
    self.name = fields[:name]
    self.availability = fields[:availability] == "true" ? true : false
    self.max_day_workload = fields[:max_day_workload]
    self.max_weight = fields[:max_weight]
    self.skip_issues = fields[:skip_issues] == "true" ? true : false

    self.walk = fields[:walk] == "true" ? true : false
    self.trot_with = fields[:trot_with] == "true" ? true : false
    self.trot_without = fields[:trot_without] == "true" ? true : false
    self.canter = fields[:canter] == "true" ? true : false
    self.hack = fields[:hack] == "true" ? true : false
    self.jump_5_meter = fields[:jump_5_meter] == "true" ? true : false
    self.jump_75_meter = fields[:jump_75_meter] == "true" ? true : false
    self.x_country = fields[:x_country] == "true" ? true : false

    self.save!
  end

  def workload date
    return "n/a" unless date
    hours = 0
    mins = 0
    self.events.where(:event_date => date, :cancelled => false).each do |event|
      duration = event.duration.split(":")
      hours += duration[0].to_i
      mins += duration[1].to_i
    end
    hours += mins/60
    mins = mins%60
    time = mins > 0 ? hours.to_s+":"+mins.to_s : hours.to_s
    time+"/"+self.max_day_workload.to_s
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

  def over_workload date, add=0
    return nil unless date
    hours = 0
    mins = 0
    self.events.where(:event_date => date, :cancelled => false).each do |event|
      duration = event.duration.split(":")
      hours += duration[0].to_i
      mins += duration[1].to_i
    end
    (hours*60)+mins+add > self.max_day_workload*60 ? true : false
  end

  def current_mins date
    return 0 unless date
    hours = 0
    mins = 0
    self.events.where(:event_date => date, :cancelled => false).each do |event|
      duration = event.duration.split(":")
      hours += duration[0].to_i
      mins += duration[1].to_i
    end
    (hours*60)+mins
  end

  def abilities
    ability = ""
    ability += "Walk, " if self.walk
    ability += "Trot with Stirrups, " if self.trot_with
    ability += "Trot without Stirrups, " if self.trot_without
    ability += "Canter, " if self.canter
    ability += "Hack, " if self.hack
    ability += "Jump 0.5m, " if self.jump_5_meter
    ability += "Jump 0.75m, " if self.jump_75_meter
    ability += "Cross-Country, " if self.x_country
    ability.length > 0 ? ability[0..-3] : "None"
  end

  def self.status
    issues = []
    Horse.where(:skip_issues => false).each do |horse|
      issues << {:link => "/bookings/search/#{horse.id}", :text => horse.name+" is overworked today - Current workload: "+horse.workload(Date.today)+"hrs"} if horse.over_workload Date.today      
      date = Date.today
      14.times do |i|
        event_splits = []
        horse.events.where(:event_date => date, :cancelled => false).each do |event|
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
        # test for consecutive lessons (first of any splits array == last of any splits array)
        event_splits.each_with_index do |event,i|
          first = event.first
          event_splits.each_with_index do |event2,j|
            if i != j
              issues << {:link => "/bookings/date/#{date.strftime("%d-%m-%Y")}", :text => horse.name+" is booked into consecutive events with no break at "+first+(date==Date.today ? " today" : " on "+date.strftime("%A #{date.strftime("%e").to_i.ordinalize} %B"))} if first == event2.last
            end
          end
        end
        # test for overlap of lessons
        event_splits.each_with_index do |event,i|
          event.each do |split|
            event_splits.each_with_index do |event2,j|
              event2.each do |split2|
                if i != j && split2 != event2.first && split2 != event2.last
                  issues << {:link => "/bookings/date/#{date.strftime("%d-%m-%Y")}", :text => horse.name+" is double-booked across different events "+(date==Date.today ? " today" : " on "+date.strftime("%A #{date.strftime("%e").to_i.ordinalize} %B"))} if split == split2
                end
              end
            end
          end
        end
        # test for double booking
        bookings = horse.bookings.where(:cancelled => false)
        bookings.each_with_index do |booking,i|
          bookings.each_with_index do |booking2,j|
            if i != j
              issues << {:link => "/bookings/date/#{date.strftime("%d-%m-%Y")}", :text => horse.name+" is double-booked for the "+booking.event.event_type.downcase.capitalize+" event at "+booking.event.start_time.strftime("%l:%M%P")+(date==Date.today ? " today" : " on "+date.strftime("%A #{date.strftime("%e").to_i.ordinalize} %B"))} if booking.event == booking2.event
            end
          end
        end
        date = date.advance(:days => 1)
      end
    end
    issues.uniq
  end
end