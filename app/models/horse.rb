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

  def workload
    hours = 0
    mins = 0
    self.events.each do |event|
      duration = event.duration.split(":")
      hours += duration[0].to_i
      mins += duration[1].to_i
    end
    hours += mins/60
    mins = mins%60
    time = mins > 0 ? hours.to_s+":"+mins.to_s : hours.to_s
    time+"/"+self.max_day_workload.to_s
  end

  def farrier_due
    if self.farrier
      date = self.farrier_date
      while date < Time.now.to_date
        date = date.to_time.advance(:days => self.farrier_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end

  def worming_due
    if self.worming
      date = self.worming_date
      while date < Time.now.to_date
        date = date.to_time.advance(:days => self.worming_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end

  def vet_due
    if self.vet
      date = self.vet_date
      while date < Time.now.to_date
        date = date.to_time.advance(:days => self.vet_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end

  def medication_due
    if self.medication
      date = self.medication_date
      while date < Time.now.to_date
        date = date.to_time.advance(:days => self.medication_freq.to_i).to_date
      end
    end
    date ? date.strftime("%Y-%m-%d") : "N/A"
  end
end