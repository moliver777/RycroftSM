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

    self.address_line_1 = fields[:address_line_1]
    self.address_line_2 = fields[:address_line_2]
    self.city = fields[:city]
    self.county = fields[:county]
    self.country = fields[:country]
    self.post_code = fields[:post_code]
    self.home_phone = fields[:home_phone]
    self.mobile_phone = fields[:mobile_phone]

    self.save!
  end

  def self.status
    []
  end
end