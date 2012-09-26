class BookingsController < ApplicationController
  def index
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end
    load_upcoming
    @unconfirmed = Booking.includes(:event).where("confirmed = ? and events.event_date >= ? and events.event_date < ?", false, Date.today, Date.today.advance(:days => 7)).order("events.event_date, events.start_time")
    @prompt = auto_assign(true)
  end

  def upcoming
    @date = Date.parse(params[:date])
    load_upcoming
    render :partial => "upcoming"
  end

  def new
    @event = params[:event_id] ? Event.find(params[:event_id]) : Event.new
    @booking = Booking.new
    @events = Event.where("event_date >= ?", Date.today).order("event_date, start_time")
    @venue_events = {}
    @horses = Horse.where(:availability => true).order("name")
  end

  def event
    event = Event.find(params[:event_id])
    event[:formatted_start_time] = event.start_time.strftime("%H:%M")
    event[:formatted_end_time] = event.end_time.strftime("%H:%M")
    render :json => event.to_json
  end

  def client_search
    if params[:search] == "ALL"
      @results = Client.order("first_name, last_name")
    else
      results = []
      clients = Client.all
      parse_search(params[:search]).split(" ").each do |term|
        clients.select{|c| c.first_name.downcase == term.downcase || c.last_name.downcase == term.downcase}.each do |result|
          results << result
        end
      end
      @results = results.compact.uniq.sort{|a,b| a.last_name <=> b.last_name}
    end
    render :partial => "client_search_results"
  end

  def client
    @client = Client.where(:id => params[:client_id]).first
    @client = Client.new unless @client
    json = {
      :fields => render_to_string(:partial => "client_fields"),
      :notes => render_to_string(:partial => "client_notes")
    }
    render :json => json
  end

  def horses
    @horses = Horse.where(:availability => true).order("name")
    @date = params[:date]
    render :partial => "horse_form"
  end

  def edit
    if params[:booking_id]
      @booking = Booking.find(params[:booking_id])
      @event = @booking.event
    else
      @event = Event.find(params[:event_id])
      @booking = Booking.new
      @event_edit_flag = true
    end
    @events = [@event]
    Event.where("event_date >= ? AND id != ?", Date.today, @event.id).order("event_date, start_time").each{|evt| @events << evt}
    @venue = Venue.where(:id => @event.master_venue_id).first
    @venues = Venue.where(:name => @venue.name) if @venue
    @venue_events = format_timetable_events(Event.where("event_date = ? AND venue_id IN (?)", @event.event_date, @venues.map{|v| v.id})) if @venues
    @horses = Horse.where(:availability => true).order("name")
    @date = @event.event_date
  end

  def reload_timetable
    @event = Event.where(:id => params[:event_id]).first
    @venue = Venue.where(:id => params[:venue_id]).first
    @venues = Venue.where(:name => @venue.name)
    @venue_events = format_timetable_events(Event.where("event_date = ? AND venue_id IN (?)", Date.parse(params[:date]), @venues.map{|v| v.id})) if @venues
    render :partial => "venue_timetable"
  end

  def show
    @booking = Booking.find(params[:booking_id])
    @event = @booking.event
  end

  def show_event
    @event = Event.find(params[:event_id])
    render "event"
  end

  def create
    validation params[:fields], 0
    json = {}
    json[:errors] = @errors
    if @validated
      # create or update client
      if params[:fields][:client]
        client = params[:fields][:client][:client_id] ? Client.find(params[:fields][:client][:client_id]) : Client.new
        client.set_fields params[:fields][:client]
      end
      # create or update event
      event = params[:fields][:event_id] ? Event.find(params[:fields][:event_id]) : Event.new
      event.set_fields params[:fields]
      json[:event_id] = event.id
      # create booking
      if client
        booking = Booking.new
        booking.set_fields event.id, client.id, params[:fields][:cost], params[:fields][:horse_id]
        json[:booking_id] = booking.id
      end
    end
    render :json => json
  end

  def update
    validation params[:fields], params[:booking_id]
    json = {}
    json[:errors] = @errors
    if @validated
      # create or update client
      client = params[:fields][:client][:client_id] ? Client.find(params[:fields][:client][:client_id]) : Client.new
      client.set_fields params[:fields][:client]
      # create or update event
      event = params[:fields][:event_id] ? Event.find(params[:fields][:event_id]) : Event.new
      event.set_fields params[:fields]
      # create booking
      booking = Booking.find(params[:booking_id])
      booking.set_fields event.id, client.id, params[:fields][:cost], params[:fields][:horse_id]
      json[:booking_id] = booking.id
    end
    render :json => json
  end

  def update_event
    validation params[:fields], params[:event_id]
    json = {}
    json[:errors] = @errors
    if @validated
      event = Event.find(params[:event_id])
      event.set_fields params[:fields]
      json[:event_id] = event.id
    end
    render :json => json
  end

  def destroy
    booking = Booking.find(params[:booking_id])
    event = booking.event
    booking.notes.destroy_all
    booking.destroy
    event.destroy unless event.bookings.first
    render :nothing => true
  end

  def destroy_event
    event = Event.find(params[:event_id])
    event.bookings.each{|b| b.notes.destroy_all}
    event.bookings.destroy_all
    event.destroy
    render :nothing => true
  end

  def status
    booking = Booking.find(params[:booking_id])
    booking.confirmed = params[:status] == "true" ? true : false
    booking.save!
    render :nothing => true
  end

  def search
    @clients = Client.order("first_name, last_name")
    @horses = Horse.order("name")
  end

  def auto_search
    @clients = Client.order("first_name, last_name")
    @horses = Horse.order("name")
    @results = []
    horse = Horse.find(params[:horse_id]) if params[:horse_id] rescue nil
    @horse_id = horse.id if horse
    Event.where(:event_date => Date.today).each do |event|
       event.bookings.where(:horse_id => horse.id).each{|b| @results << b} if horse
    end
    render "search"
  end

  def search_results
    @results = []
    client = Client.find(params[:fields][:client]) if params[:fields][:client]
    horse = Horse.find(params[:fields][:horse]) if params[:fields][:horse]
    Event.where("event_date BETWEEN ? AND ?", params[:fields][:from_date], params[:fields][:to_date]).order("event_date DESC, start_time DESC").each do |event|
      if client && horse
        event.bookings.where(:client_id => client.id, :horse_id => horse.id).each{|b| @results << b}
      elsif client
        event.bookings.where(:client_id => client.id).each{|b| @results << b}
      elsif horse
        event.bookings.where(:horse_id => horse.id).each{|b| @results << b}
      else
        event.bookings.each{|b| @results << b}
      end
    end
    render :json => {:view => render_to_string(:partial => "booking_search_results")}.to_json
  end

  def available_now
    render :partial => "available_now"
  end

  def available_now_fields
    @start_time = get_start_time
    @end_time = get_end_time @start_time, params[:duration].to_i
    @formatted_start_time = format_time @start_time
    @formatted_end_time = format_time @end_time
    @event_types = Event::TYPES
    required = get_required @start_time, @end_time
    temp_venues = []
    v_unique = []
    @clients = Client.order("first_name, last_name")
    @venues = []
    @staff = []
    @horses = []
    # get available venues
    Venue.all.each do |v|
      splits = []
      available = true
      v.events.each{|e| splits << e.get_splits}
      required.each{|r| available = false if splits.flatten.include? r}
      temp_venues << v if available
    end
    # unique venues (one for each master name)
    temp_venues.each do |v|
      if !v_unique.include? v.name
        v_unique << v.name
        @venues << v
      end
    end
    # get available staff
    Staff.all.each do |s|
      splits = []
      available = true
      if s.is_available Date.today.strftime("%a")
        s.events.each{|e| splits << e.get_splits}
        required.each{|r| available = false if splits.flatten.include? r}
        @staff << s if available
      end
    end
    # get available horses
    Horse.where(:availability => true).each do |h|
      splits = []
      available = true
      h.events.each{|e| splits << e.get_splits}
      [required,@start_time,@end_time].flatten.each{|r| available = false if splits.flatten.include? r}
      available = false if h.over_workload(Date.today, params[:duration].to_i)
      @horses << h if available
    end
    render :partial => "available_now_fields"
  end

  def available_now_complete
    errors = []
    booking_id = nil
    if params[:fields][:event_type] == "0" || params[:fields][:venue_id] == "0" || params[:fields][:client_id] =="0" || params[:fields][:horse_id] == "0" || params[:fields][:staff_id] == "0"
      errors << "You must make a selection for ALL fields"
    else
      event = Event.new
      actual = Venue.find(params[:fields][:venue_id])
      master = Venue.where(:name => actual.name, :master => true).first
      params[:fields][:master_venue_id] = master.id
      params[:fields][:event_date] = Date.today
      event.set_fields params[:fields]
      booking = Booking.new
      booking.confirmed = true
      booking.set_fields event.id, params[:fields][:client_id], params[:fields][:cost], params[:fields][:horse_id]
      booking_id = booking.id
    end
    render :json => {:errors => errors, :booking_id => booking_id}
  end

  def payment
    @booking = Booking.find(params[:booking_id]) rescue nil
    @event = @booking.event if @booking
  end

  def create_payment
    validate_payment params[:fields]
    json = {}
    json[:errors] = @errors
    if @validated
      payment = Payment.new
      payment.set_fields params[:fields]
    end
    render :json => json
  end

  def delete_payment
    Payment.find(params[:payment_id]).destroy rescue nil
    render :nothing => true
  end

  def other_payment
    @payments = Payment.where(:booking_id => nil, :payment_date => Date.today).order("created_at ASC")
  end

  def cash_up
    @date = params[:date] ? (Date.parse(params[:date]) rescue nil) : Date.today
    @totals = {"cash" => 0.00, "card" => 0.00, "cheque" => 0.00, "voucher" => 0.00, "total" => 0.00}
    @payments = Payment.where(:payment_date => @date).group_by{|p| p.friendly_type.downcase}
    @payments.each do |type,payments|
      payments.each do |p|
        @totals[type] += p.amount
        @totals["total"] += p.amount
      end
    end
  end

  def rebook
    @booking = Booking.find(params[:booking_id])
    data = render_to_string(:partial => "rebook")
    render :json => data.to_json
  end

  def rebook_status
    # validate rebook
    json = {}
    json[:errors] = []
    venue_id = nil
    old_booking = Booking.find(params[:booking_id])
    old_event = old_booking.event
    Venue.where(:name => old_event.venue.name).order("id DESC").each do |venue|
      venue_id = venue.id unless Event.where("event_date = ? AND venue_id = ? AND start_time < ? AND end_time > ?", params[:event_date], venue.id, params[:end_time], params[:start_time]).first
    end
    valid = true
    if params[:cost].to_f < 0.00
      json[:errors] << "Cost cannot be less than 0." 
      valid = false
    end
    if venue_id && valid
      new_event = Event.new
      new_event.rebook old_event, venue_id, params
      new_booking = Booking.new
      new_booking.rebook old_booking, new_event, params
      json[:booking_id] = new_booking.id
    else
      json[:errors] << "Could not rebook at this time."
      hr = 7
      min = 0
      splits = []
      while hr < 23 || min < 15
        current = "#{0 if hr < 10}#{hr}:#{0 if min < 10}#{min}"
        splits << current unless Event.where("event_date = ? AND venue_id IN (?) AND start_time < ? AND end_time > ?", params[:event_date], Venue.where(:name => old_event.venue.name).map{|v| v.id}, current, current).first
        min == 45 ? min = 0 : min += 15
        hr += 1 if min == 0
      end
      json[:errors] << (splits[0] ? "Available times for #{old_event.venue.name}: "+available_times(splits) : "No available times!")
      json[:errors] << "If you are having problems, try opening the schedule for the desired day in a new window to see if the event is trying to book across different rows, or go to the new booking form and attempt to make the booking manually."
    end
    render :json => json
  end

  private

  def load_upcoming
    @upcoming = Event.includes(:bookings).where(:event_date => @date).order("start_time")
  end

  def format_timetable_events events
    formatted_events = []
    events.each do |event|
      formatted_event = {
        "id" => event.id,
        "hour" => event.start_time.strftime("%H"),
        "mins" => event.start_time.strftime("%M"),
        "duration" => event.segment_duration,
        "venue_id" => event.venue_id
      }
      formatted_events << formatted_event
    end
    formatted_events
  end

  def validation fields, id
    @errors = []
    # event validation
    @errors << "Event must have an event type." if fields[:event_type] == "0"
    @errors << "Event must be assigned to a venue." if fields[:master_venue_id] == "0"
    begin
      Date.parse(fields[:event_date])
    rescue
      @errors << "Event date is invalid."
    end
    @errors << "Must select a start time." unless fields[:start_time].length > 0
    @errors << "Must select an end time." unless fields[:end_time].length > 0
    # cost validation
    if fields[:cost]
      @errors << "Cost cannot be less than 0." if fields[:cost].to_f < 0.00
    end
    # client validation
    if fields[:client]
      fields = fields[:client]
      @errors << "Client must have a first name." unless fields[:first_name].length > 0
      @errors << "Client must have a last name." unless fields[:last_name].length > 0
      if fields[:date_of_birth].length > 0
        begin
          Date.parse(fields[:year]+"-"+fields[:month]+"-"+fields[:day])
        rescue
          @errors << "Date of birth is invalid."
        end
      end
      @errors << "Client must have a riding standard." if fields[:standard] == "0"
      if fields[:home_phone].length > 0
        @errors << "Home phone number is invalid." unless fields[:home_phone].match(/[0-9]{6,}/)
        @errors << "Home phone number is invalid." if fields[:home_phone].match(/\D/)
      end
      if fields[:mobile_phone].length > 0
        @errors << "Mobile phone number is invalid." unless fields[:mobile_phone].match(/[0-9]{6,}/)
        @errors << "Mobile phone number is invalid." if fields[:mobile_phone].match(/\D/)
      end
    end
    @validated = @errors.length > 0 ? false : true
  end

  def validate_payment fields
    @errors = []
    @errors << "Amount must be greater than 0." unless fields[:amount].to_f > 0
    if !fields.include? :booking_id
      @errors << "Must have a description." unless fields[:description].length > 0
    end
    @validated = @errors.length > 0 ? false : true
  end

  def parse_search search
    @search = ""
    search.split("").each do |char|
      @search += char if char.match(/\w|\s|\"|\'|\-/)
    end
    @search
  end

  def available_times splits
    result = ""
    prev = ""
    hr = splits[0].split(":")[0].to_i
    min = splits[0].split(":")[1].to_i
    first = true
    splits.each do |s|
      if s == splits.first
        result += s
      elsif s == splits.last
        if first
          result += "-#{s}"
        else
          result += s
        end
      else
        if s == "#{0 if hr < 10}#{hr}:#{0 if min < 10}#{min}"
          if first
            first = false
            result += "-"
          end
        else
          if first
            result += ", #{s}"
          else
            result += "#{prev}, #{s}"
            first = true
          end
          hr = s.split(":")[0].to_i
          min = s.split(":")[1].to_i
        end
      end
      prev = s
      min == 45 ? min = 0 : min += 15
      hr += 1 if min == 0
    end
    result
  end

  def get_start_time
    hour = params[:hour].to_i
    mins = params[:mins].to_i
    mins += 1 while mins%15 != 0
    mins = 0 if mins == 60
    hour += 1 if mins == 0
    new_hour = hour < 10 ? "0#{hour}" : "#{hour}"
    new_mins = mins == 0 ? "00" : "#{mins}"
    new_hour+":"+new_mins
  end

  def get_end_time start_time, duration
    hour = start_time.split(":")[0].to_i
    mins = start_time.split(":")[1].to_i
    (duration/15).times do |i|
      mins += 15
      mins = 0 if mins == 60
      hour += 1 if mins == 0
    end
    new_hour = hour < 10 ? "0#{hour}" : "#{hour}"
    new_mins = mins == 0 ? "00" : "#{mins}"
    new_hour+":"+new_mins
  end

  def get_required start_time, end_time
    splits = []
    hour = start_time.split(":")[0].to_i
    mins = start_time.split(":")[1].to_i
    mins += 15
    mins = 0 if mins == 60
    hour += 1 if mins == 0
    new_hour = hour < 10 ? "0#{hour}" : "#{hour}"
    new_mins = mins == 0 ? "00" : "#{mins}"
    new_time = new_hour+":"+new_mins
    while new_time != end_time
      splits << new_time
      mins += 15
      mins = 0 if mins == 60
      hour += 1 if mins == 0
      new_hour = hour < 10 ? "0#{hour}" : "#{hour}"
      new_mins = mins == 0 ? "00" : "#{mins}"
      new_time = new_hour+":"+new_mins
    end
    splits
  end

end