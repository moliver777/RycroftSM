class Horse < ActiveRecord::Base
  BEGINNER = "BEGINNER"
  INTERMEDIATE = "INTERMEDIATE"
  ADVANCED = "ADVANCED"
  STANDARDS = [BEGINNER,INTERMEDIATE,ADVANCED]

  has_many :bookings
  has_many :notes
  has_many :events, :through => :bookings

  def set_fields fields
    self.name = fields[:name]
    self.standard = fields[:standard]
    self.availability = fields[:availability] == "true" ? true : false
    self.max_day_workload = fields[:max_day_workload]

    self.farrier = fields[:farrier] == "true" ? true : false
    self.farrier_date = fields[:farrier_date] if self.farrier
    self.farrier_freq = fields[:farrier_freq] if self.farrier
    self.worming = fields[:worming] == "true" ? true : false
    self.worming_date = fields[:worming_date] if self.worming
    self.worming_freq = fields[:worming_freq] if self.worming
    self.vet = fields[:vet] == "true" ? true : false
    self.vet_date = fields[:vet_date] if self.vet
    self.vet_freq = fields[:vet_freq] if self.vet
    self.medication = fields[:medication] == "true" ? true : false
    self.medication_date = fields[:medication_date] if self.medication
    self.medication_freq = fields[:medication_freq] if self.medication

    self.save!
  end

  def workload date
    return "n/a" unless date
    hours = 0
    mins = 0
    self.events.where(:event_date => date).each do |event|
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
    self.events.where(:event_date => from..to).each do |event|
      duration = event.duration.split(":")
      hours += duration[0].to_i
      mins += duration[1].to_i
    end
    hours += mins/60
    mins = mins%60
    mins > 0 ? hours.to_s+"."+((mins/15)*25).to_s : hours.to_s
  end

  def over_workload date
    return nil unless date
    hours = 0
    mins = 0
    self.events.where(:event_date => date).each do |event|
      duration = event.duration.split(":")
      hours += duration[0].to_i
      mins += duration[1].to_i
    end
    (hours*60)+mins > self.max_day_workload*60 ? true : false
  end

  def farrier_due
    if self.farrier
      date = self.farrier_date
      while date < Time.now.to_date
        date = date.to_time.advance(:weeks => self.farrier_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end

  def worming_due
    if self.worming
      date = self.worming_date
      while date < Time.now.to_date
        date = date.to_time.advance(:weeks => self.worming_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end

  def vet_due
    if self.vet
      date = self.vet_date
      while date < Time.now.to_date
        date = date.to_time.advance(:weeks => self.vet_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end

  def medication_due
    if self.medication
      date = self.medication_date
      while date < Time.now.to_date
        date = date.to_time.advance(:weeks => self.medication_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end

  def self.status
    issues = []
    Horse.all.each do |horse|
      issues << {:link => "/bookings/search/"+horse.id.to_s, :text => horse.name+" is overworked today - Current workload: "+horse.workload(Date.today)+"hrs"} if horse.over_workload Date.today
      event_splits = []
      horse.events.where(:event_date => Date.today).each do |event|
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
            issues << {:link => "/bookings/search/"+horse.id.to_s, :text => horse.name+" is booked into consecutive events with no break at "+first} if first == event2.last
          end
        end
      end
      # test for overlap of lessons
      event_splits.each_with_index do |event,i|
        event.each do |split|
          event_splits.each_with_index do |event2,j|
            event2.each do |split2|
              if i != j && split2 != event2.first && split2 != event2.last
                issues << {:link => "/bookings/search/"+horse.id.to_s, :text => horse.name+" is double-booked across different events"} if split == split2
              end
            end
          end
        end
      end
      # test for double booking
      bookings = horse.bookings
      bookings.each_with_index do |booking,i|
        bookings.each_with_index do |booking2,j|
          if i != j
            issues << {:link => "/bookings/search/"+horse.id.to_s, :text => horse.name+" is double-booked for the "+booking.event.name+" event at "+booking.event.start_time.strftime("%H:%M")} if booking.event == booking2.event
          end
        end
      end
    end
    issues.uniq
  end
end