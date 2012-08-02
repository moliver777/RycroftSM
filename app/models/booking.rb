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
    []
  end
end