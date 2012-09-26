class PrintingController < ApplicationController

  layout false

  def schedule
    if params.include? :date
      @events = Event.where(:event_date => params[:date]).order("start_time")
      @date = Date.parse(params[:date])
    else
      @events = Event.where(:event_date => Date.today).order("start_time")
      @date = Date.today
    end
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
    @totals = {"cash" => 0.00, "card" => 0.00, "cheque" => 0.00, "voucher" => 0.00, "total" => 0.00}
    @payments = Payment.where(:payment_date => @date).group_by{|p| p.friendly_type.downcase}
    @payments.each do |type,payments|
      payments.each do |p|
        @totals[type] += p.amount
        @totals["total"] += p.amount
      end
    end
  end
end