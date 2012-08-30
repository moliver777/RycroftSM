class Payment < ActiveRecord::Base
  belongs_to :booking

  def set_fields fields
    self.booking_id = fields[:booking_id]
    self.cash = true if fields[:payment_type] = "cash"
    self.cc = true if fields[:payment_type] = "card"
    self.cheque = true if fields[:payment_type] = "cheque"
    self.amount = fields[:amount]
    self.payment_date = Date.today

    self.save!
  end

  def friendly_type
    text = ""
    if self.cash
      text = "Cash"
    elsif self.cc
      text = "Card"
    elsif self.cheque
      text = "Cheque"
    end
    text
  end
end