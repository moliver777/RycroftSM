class Staff < ActiveRecord::Base
  has_many :events
  has_many :notes
end