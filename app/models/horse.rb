class Horse < ActiveRecord::Base
  BEGINNER = "BEGINNER"
  INTERMEDIATE = "INTERMEDIATE"
  ADVANCED = "ADVANCED"
  STANDARDS = [BEGINNER,INTERMEDIATE,ADVANCED]

  has_many :bookings
  has_many :notes

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