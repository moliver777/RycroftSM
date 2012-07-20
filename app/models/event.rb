class Event < ActiveRecord::Base
  BEGINNER = "BEGINNER"
  INTERMEDIATE = "INTERMEDIATE"
  ADVANCED = "ADVANCED"
  STANDARDS = [BEGINNER,INTERMEDIATE,ADVANCED]

  PRIVATE = "PRIVATE"
  GROUP = "GROUP"
  INTRODUCTORY = "INTRODUCTORY"
  TYPES = [PRIVATE,GROUP,INTRODUCTORY]

  has_many :bookings
  has_many :staff
  has_many :clients, :through => :bookings
  has_many :horses, :through => :bookings
  has_one :venue
end