class PrintingController < ApplicationController

  layout false

  def schedule
    if params.include? :date
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end
    @events = Event.where(:event_date => @date, :cancelled => false).order("start_time")
    @staff = {}
    Staff.where(hidden: false).order("first_name, last_name").each do |s|
      @events.each do |e|
        if e.staff_id == s.id || e.staff_id2 == s.id || e.staff_id3 == s.id
          @staff["#{s.first_name} #{s.last_name}"] = [] unless @staff["#{s.first_name} #{s.last_name}"]
          @staff["#{s.first_name} #{s.last_name}"] << e
        end
      end
    end
    @turnouts = []
    Horse.where(hidden: false).order("name").each do |horse|
      horse_events = horse.events.where(:event_date => @date, :cancelled => false).order("end_time")
      if horse_events.first
        @turnouts << {:name => horse.name, :turnout => true, :time => horse_events.last.end_time.strftime("%H:%M"), :formatted_time => horse_events.last.end_time.strftime("%l:%M%P")}
      else
        @turnouts << {:name => horse.name, :turnout => false, :time => "00:00"}
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

  def reports
    @from = params[:from_date]
    @to = params[:to_date]
    horse_workloads
    staff_workloads
    horse_events
    client_ages
    client_events
    # client_standards
    event_types
    bookings_by_day
    bookings_by_hour
    @from = Date.parse(@from)
    @to = Date.parse(@to)
  end

  def end_of_day
    if params.include? :date
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end
    @events = Event.where(:event_date => @date, :cancelled => false).order("start_time")
    @totals = {"cash" => 0.00, "card" => 0.00, "cheque" => 0.00, "voucher" => 0.00, "hours" => 0.00, "foc" => 0.00, "total" => 0.00}
    @payments = Payment.where(:payment_date => @date).group_by{|p| p.friendly_type.downcase}
    @payments.each do |type,payments|
      payments.each do |p|
        @totals[type] += p.amount
        @totals["total"] += p.amount unless type=="voucher" || type=="hours" || type=="foc"
      end
    end
    @end_of_week = false
    horse_workloads = []
    Horse.where(hidden: false).each do |horse|
      horse_workloads << {:name => horse.name, :workload => horse.workload_period(@date, @date).to_f}
    end
    @horse_workloads = horse_workloads.sort_by{|h| h[:workload]}.reverse
    staff_workloads = []
    Staff.where(hidden: false).each do |staff|
      staff_workloads << {:name => "#{staff.first_name} #{staff.last_name}", :workload => staff.workload_period(@date, @date).to_f} unless staff.first_name == "Horse"
    end
    @staff_workloads = staff_workloads.sort_by{|s| s[:workload]}.reverse
    if @date.strftime("%a") == "Sun"
      @end_of_week = true
      week_horse_workloads = []
      Horse.all.each do |horse|
        week_horse_workloads << {:name => horse.name, :workload => horse.workload_period(@date.advance(:days => -7), @date).to_f}
      end
      @week_horse_workloads = week_horse_workloads.sort_by{|h| h[:workload]}.reverse
    end
  end
end