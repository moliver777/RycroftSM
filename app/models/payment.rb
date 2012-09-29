class Payment < ActiveRecord::Base
  belongs_to :booking

  def set_fields fields
    if fields.include? :booking_id
      self.booking_id = fields[:booking_id]
      self.description = fields[:description] if fields[:description].length > 0
    else
      self.reference = fields[:reference]
      self.description = fields[:description]
    end
    self.cash = true if fields[:payment_type] == "cash"
    self.cc = true if fields[:payment_type] == "card"
    self.cheque = true if fields[:payment_type] == "cheque"
    self.voucher = true if fields[:payment_type] == "voucher"
    self.hours = true if fields[:payment_type] == "hours"
    self.foc = true if fields[:payment_type] == "foc"
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
    elsif self.voucher
      text = "Voucher"
    elsif self.hours
      text = "Hours"
    elsif self.foc
      text = "FOC"
    end
    text
  end
end