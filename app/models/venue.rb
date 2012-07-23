class Venue < ActiveRecord::Base
  def set_fields fields
    self.name = fields[:name]
    self.description = fields[:description]

    self.save
  end
end