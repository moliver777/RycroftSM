class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :client
  belongs_to :horse
  has_many :notes
  has_many :payments

  def set_fields event, client, horse
    self.event_id = event if event
    self.client_id = client if client
    self.horse_id = horse && Horse.where(:id => horse).first ? horse : nil

    self.save!
  end

  def rebook old, event, fields
    self.event_id = event.id
    self.client_id = old.client_id
    self.cost = fields[:cost]
    self.horse_id = nil
    old.rebooked = true

    self.save!
    old.save!
  end

  def balance
    self.cost - self.payments.sum("amount")
  end

  def self.status
    issues = []
    Booking.includes(:event).where("events.event_type IN (?)", Event::HORSE).select{|booking| booking.event.event_date == Date.today}.each do |booking|
      if booking.client
        issues << {:link => "/bookings/edit/"+booking.id.to_s, :text => booking.client.first_name+" "+booking.client.last_name+"'s booking for at "+booking.event.start_time.strftime("%l:%M%P")+" has no horse assigned to it"} unless booking.horse
      end
    end
    issues.uniq
  end
end