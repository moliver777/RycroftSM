class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :client
  belongs_to :horse
  has_many :notes
  has_many :payments

  def set_fields event, client, cost, horse
    self.event_id = event if event
    self.client_id = client if client
    self.cost = cost.to_f if cost
    self.horse_id = horse && Horse.where(:id => horse).first ? horse : nil

    self.save!
  end

  def rebook old, event, fields
    self.event_id = event.id
    self.client_id = old.client_id
    self.cost = fields[:cost]
    self.horse_id = nil

    self.save!
  end

  def balance
    self.cost - self.payments.sum("amount")
  end

  def self.status
    issues = []
    Booking.includes(:event).all.select{|booking| booking.event.event_date == Date.today}.each do |booking|
      issues << {:link => "/bookings/edit/"+booking.id.to_s, :text => booking.client.first_name+" "+booking.client.last_name+"'s booking for at "+booking.event.start_time.strftime("%H:%M")+" has no horse assigned to it"} unless booking.horse
    end
    issues.uniq
  end
end