class Venue < ActiveRecord::Base
  has_many :events

  def set_fields fields, master
    self.name = fields[:name]
    self.description = fields[:description]
    self.master = master

    self.save
  end

  def capacity
    Venue.where(:name => self.name).count rescue 0
  end
end