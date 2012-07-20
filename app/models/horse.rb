class Horse < ActiveRecord::Base
  has_many :bookings
  has_many :notes
end