class PrintingController < ApplicationController

  layout false

  def schedule
    if params.include? :date
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end
    @events = Event.where(:event_date => @date).order("start_time")
    @staff = {}
    Staff.order("first_name, last_name").each do |s|
      @events.each do |e|
        if e.staff_id == s.id || e.staff_id2 == s.id || e.staff_id3 == s.id
          @staff["#{s.first_name} #{s.last_name}"] = [] unless @staff["#{s.first_name} #{s.last_name}"]
          @staff["#{s.first_name} #{s.last_name}"] << e
        end
      end
    end
  end

  def client
    @client = Client.find(params[:client_id])
  end

  def event
    @event = Event.find(params[:event_id])
  end

  def booking
    @booking = Booking.find(params[:booking_id])
    @event = @booking.event
  end

  def cash_up
    @date = params[:date] ? params[:date] : Date.today
    @totals = {"cash" => 0.00, "card" => 0.00, "cheque" => 0.00, "voucher" => 0.00, "hours" => 0.00, "foc" => 0.00, "total" => 0.00}
    @payments = Payment.where(:payment_date => @date).group_by{|p| p.friendly_type.downcase}
    @payments.each do |type,payments|
      payments.each do |p|
        @totals[type] += p.amount
        @totals["total"] += p.amount unless type=="voucher" || type=="hours" || type=="foc"
      end
    end
  end
end