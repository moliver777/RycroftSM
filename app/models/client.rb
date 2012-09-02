class Client < ActiveRecord::Base
  BEGINNER = "BEGINNER"
  INTERMEDIATE = "INTERMEDIATE"
  ADVANCED = "ADVANCED"
  STANDARDS = [BEGINNER,INTERMEDIATE,ADVANCED]

  has_many :bookings
  has_many :notes
  has_many :events, :through => :bookings

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
    self.standard = fields[:standard]
    self.last_reminder = Date.today

    self.address_line_1 = fields[:address_line_1]
    self.address_line_2 = fields[:address_line_2]
    self.city = fields[:city]
    self.county = fields[:county]
    self.country = fields[:country]
    self.post_code = fields[:post_code]
    self.home_phone = fields[:home_phone]
    self.mobile_phone = fields[:mobile_phone]

    self.emergency_contact_name = fields[:emergency_contact_name]
    self.emergency_contact_phone = fields[:emergency_contact_phone]

    self.save!
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.date_of_birth.year - ((now.month > self.date_of_birth.month || (now.month == self.date_of_birth.month && now.day >= self.date_of_birth.day)) ? 0 : 1)
  end

end