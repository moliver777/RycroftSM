class Event < ActiveRecord::Base
  has_many :bookings
  has_many :staff
  has_many :clients, :through => :bookings
  has_many :horses, :through => :bookings
  has_one :venue
end