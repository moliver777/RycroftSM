class Client < ActiveRecord::Base
  LEADREIGN = "LEAD-REIGN"
  BEGINNER = "BEGINNER"
  INTERMEDIATE = "INTERMEDIATE"
  ADVANCED = "ADVANCED"
  STANDARDS = [LEADREIGN,BEGINNER,INTERMEDIATE,ADVANCED]

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
    self.date_of_birth = fields[:day]+"-"+fields[:month]+"-"+fields[:year]
    self.last_reminder = Date.today

    self.address_line_1 = fields[:address_line_1]
    self.address_line_2 = fields[:address_line_2]
    self.city = fields[:city]
    self.county = fields[:county]
    self.country = fields[:country]
    self.post_code = fields[:post_code]
    self.home_phone = fields[:home_phone]
    self.mobile_phone = fields[:mobile_phone]
    # self.email = fields[:email_address]
    self.height = fields[:height]
    self.weight = fields[:weight]

    self.injury = fields[:injury] == "true" ? true : false
    self.injury_details = fields[:injury_details]
    self.medical_notes = fields[:medical_notes]
    self.doctor = fields[:doctor]
    self.doctor_contact = fields[:doctor_contact]
    self.tetanus_date = fields[:tetanus_date]
    self.emergency_contact_name = fields[:emergency_contact_name]
    self.emergency_contact_phone = fields[:emergency_contact_phone]

    self.times_ridden = fields[:times_ridden]
    self.standard = fields[:standard] unless fields[:standard]=="0"
    self.heard_about_us = fields[:heard_about_us]
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

  def set_horses fields
    self.leasing = fields[:leasing] == "0" ? nil : fields[:leasing]
    self.horses = fields[:horses].join(";") rescue nil
    self.save!
  end

  def age
    return 0 unless self.date_of_birth
    now = Time.now.utc.to_date
    now.year - self.date_of_birth.year - ((now.month > self.date_of_birth.month || (now.month == self.date_of_birth.month && now.day >= self.date_of_birth.day)) ? 0 : 1)
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
    Client.all.each do |client|
      if client.horses
        # issues << {:link => "/clients/horse_assignment_list", :text => "Some clients have no horses enabled for auto-assign. Click here to set horses"} if !client.leasing && client.horses.split(";").length==0
        issues << {:link => "/clients", :text => "Some clients have no horses enabled for auto-assign. Click here to set horses"} if !client.leasing && client.horses.split(";").length==0
      else
        # issues << {:link => "/clients/horse_assignment_list", :text => "Some clients have no horses enabled for auto-assign. Click here to set horses"}
        issues << {:link => "/clients", :text => "Some clients have no horses enabled for auto-assign. Click here to set horses"}
      end
    end
    issues.uniq
  end

end