class Note < ActiveRecord::Base
  GENERAL = "GENERAL"
  BOOKING = "BOOKING"
  CLIENT = "CLIENT"
  HORSE = "HORSE"
  STAFF = "STAFF"
  CATEGORIES = [GENERAL,BOOKING,CLIENT,HORSE,STAFF]

  belongs_to :booking
  belongs_to :client
  belongs_to :horse
  belongs_to :staff
end