class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :client
  belongs_to :horse
  has_many :notes

  def set_fields event, client, horse
    self.event_id = event if event
    self.client_id = client if client
    self.horse_id = horse if horse && Horse.where(:id => horse).first

    self.save!
  end

  def self.status
    issues = []
    Booking.all.each do |booking|
      issues << {:link => "/bookings", :text => booking.client.first_name+" "+booking.client.last_name+"'s booking for "+booking.event.name+" at "+booking.event.start_time.strftime("%H:%M")+" has no horse assigned to it.<br/>Click here to go to the bookings section."}
    end
    issues.uniq
  end
end