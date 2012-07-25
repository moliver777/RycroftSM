class Venue < ActiveRecord::Base
  has_many :events

  def set_fields fields
    self.name = fields[:name]
    self.description = fields[:description]

    self.save
  end
end