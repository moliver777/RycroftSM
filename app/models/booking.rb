class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :client
  belongs_to :horse
  has_many :notes
end