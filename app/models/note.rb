class Note < ActiveRecord::Base
  belongs_to :booking
  belongs_to :client
  belongs_to :horse
  belongs_to :staff
end