class Stock < ActiveRecord::Base
  def set_fields fields
    self.name = fields[:name]
    self.description = fields[:description]
    self.cost = fields[:cost].to_f
    self.quantity = fields[:quantity].to_i
    self.save
  end

  def update_quantity direction
    if direction == "ASC"
      self.quantity += 1
    else
      self.quantity -= 1 if self.quantity > 0
    end
    self.save!
    return self.quantity
  end

  def sell
    self.quantity -= 1 if self.quantity > 0
    self.save
  end

  def return
    self.quantity += 1
    self.save
  end

  def check_stock quantity
    raise "#{self.quantity} of #{self.name} left in stock." if self.quantity < quantity
    return [true,nil]
  rescue StandardError => e
    return [false,e.message]
  end
end