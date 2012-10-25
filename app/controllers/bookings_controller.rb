class BookingsController < ApplicationController
  skip_before_filter :application_status, :except => :index

  def index
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end
    load_upcoming
    @unconfirmed = Booking.includes(:event).where("confirmed = ? AND bookings.cancelled = ? AND events.event_date >= ? AND events.event_date < ?", false, false, Date.today, Date.today.advance(:days => 7)).order("events.event_date, events.start_time")
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
    @events = Event.where("event_date >= ? AND cancelled = ?", Date.today, false).order("event_date, start_time")
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
    @staff1 = Staff.where(:id => @event.staff_id).first
    @staff2 = Staff.where(:id => @event.staff_id2).first
    @staff3 = Staff.where(:id => @event.staff_id3).first
    @staff1_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND (staff_id = ? OR staff_id2 = ? OR staff_id3 = ?)", @event.event_date, false, @staff1.id, @staff1.id, @staff1.id)) if @staff1
    @staff2_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND (staff_id = ? OR staff_id2 = ? OR staff_id3 = ?)", @event.event_date, false, @staff2.id, @staff2.id, @staff2.id)) if @staff2
    @staff3_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND (staff_id = ? OR staff_id2 = ? OR staff_id3 = ?)", @event.event_date, false, @staff3.id, @staff3.id, @staff3.id)) if @staff3
    @horse = Horse.where(:id => @booking.horse).first
    @horse_events = format_timetable_events(Event.includes(:bookings).where("event_date = ? AND events.cancelled = ? AND bookings.cancelled = ? AND bookings.horse_id = ?", @event.event_date, false, false, @horse.id)) if @horse
    @events = [@event]
    Event.where("event_date >= ? AND cancelled = ? AND id != ?", Date.today, false, @event.id).order("event_date, start_time").each{|evt| @events << evt}
    @venue = Venue.where(:id => @event.master_venue_id).first
    @venues = Venue.where(:name => @venue.name) if @venue
    @venue_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND venue_id IN (?)", @event.event_date, false, @venues.map{|v| v.id})) if @venues
    @horses = Horse.where(:availability => true).order("name")
    @date = @event.event_date
  end

  def reload_timetable
    begin
      @event = Event.where(:id => params[:event_id]).first
      @venue = Venue.where(:id => params[:venue_id]).first
      @venues = Venue.where(:name => @venue.name)
      @venue_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND venue_id IN (?)", Date.parse(params[:date]), false, @venues.map{|v| v.id})) if @venues
    rescue
      puts "No venue selected"
    end
    render :partial => "venue_timetable"
  end

  def reload_staff
    @event = Event.where(:id => params[:event_id]).first
    @staff1 = Staff.where(:id => params[:staff_id]).first
    @staff2 = Staff.where(:id => params[:staff_id2]).first
    @staff3 = Staff.where(:id => params[:staff_id3]).first
    @staff1_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND (staff_id = ? OR staff_id2 = ? OR staff_id3 = ?)", Date.parse(params[:date]), false, @staff1.id, @staff1.id, @staff1.id)) if @staff1
    @staff2_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND (staff_id = ? OR staff_id2 = ? OR staff_id3 = ?)", Date.parse(params[:date]), false, @staff2.id, @staff2.id, @staff2.id)) if @staff2
    @staff3_events = format_timetable_events(Event.where("event_date = ? AND cancelled = ? AND (staff_id = ? OR staff_id2 = ? OR staff_id3 = ?)", Date.parse(params[:date]), false, @staff3.id, @staff3.id, @staff3.id)) if @staff3
    render :partial => "staff_timetable"
  end

  def reload_horse
    @event = Event.where(:id => params[:event_id]).first
    @horse = Horse.where(:id => params[:horse_id]).first
    @horse_events = format_timetable_events(Event.includes(:bookings).where("event_date = ? AND events.cancelled = ? AND bookings.cancelled = ? AND bookings.horse_id = ?", Date.parse(params[:date]), false, false, @horse.id)) if @horse
    render :partial => "horse_timetable"
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
    @evt = params[:fields][:event_id] ? Event.find(params[:fields][:event_id]) : Event.new
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
        booking.set_fields event.id, client.id, params[:fields][:horse_id]
        json[:booking_id] = booking.id
      end
    end
    render :json => json
  end

  def update
    @evt = params[:fields][:event_id] ? Event.find(params[:fields][:event_id]) : Event.new
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
      booking.set_fields event.id, client.id, params[:fields][:horse_id]
      json[:booking_id] = booking.id
    end
    render :json => json
  end

  def update_event
    @evt = params[:fields][:event_id] ? Event.find(params[:fields][:event_id]) : Event.new
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

  def cancel
    booking = Booking.find(params[:booking_id])
    event = booking.event
    booking.notes.each do |n|
      n.hidden = true
      n.save!
    end
    booking.cancelled = true
    booking.horse_id = nil
    booking.save!
    unless event.bookings.where(:cancelled => false).first
      event.cancelled = true
      event.staff_id = true
      event.staff_id2 = true
      event.staff_id3 = true
      event.save!
    end
    render :nothing => true
  end

  def cancel_event
    event = Event.find(params[:event_id])
    event.bookings.each do |b|
      b.cancelled = true
      b.horse_id = nil
      b.save!
      b.notes.each do |n|
        n.hidden = true
        n.save!
      end
    end
    event.cancelled = true
    event.staff_id = true
    event.staff_id2 = true
    event.staff_id3 = true
    event.save!
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
    Event.where(:event_date => Date.today, :cancelled => false).each do |event|
       event.bookings.where(:horse_id => horse.id, :cancelled => false).each{|b| @results << b} if horse
    end
    render "search"
  end

  def search_results
    @results = []
    client = Client.find(params[:fields][:client]) if params[:fields][:client]
    horse = Horse.find(params[:fields][:horse]) if params[:fields][:horse]
    Event.where("cancelled = ? AND event_date BETWEEN ? AND ?", false, params[:fields][:from_date], params[:fields][:to_date]).order("event_date DESC, start_time DESC").each do |event|
      if client && horse
        event.bookings.where(:client_id => client.id, :horse_id => horse.id, :cancelled => false).each{|b| @results << b}
      elsif client
        event.bookings.where(:client_id => client.id, :cancelled => false).each{|b| @results << b}
      elsif horse
        event.bookings.where(:horse_id => horse.id, :cancelled => false).each{|b| @results << b}
      else
        event.bookings.where(:cancelled => false).each{|b| @results << b}
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
      v.events.where(:cancelled => false).each{|e| splits << e.get_splits}
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
        s.events.where(:cancelled => false).each{|e| splits << e.get_splits}
        required.each{|r| available = false if splits.flatten.include? r}
        @staff << s if available
      end
    end
    # get available horses
    Horse.where(:availability => true).each do |h|
      splits = []
      available = true
      h.events.where(:cancelled => false).each{|e| splits << e.get_splits}
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
      booking.set_fields event.id, params[:fields][:client_id], params[:fields][:horse_id]
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
    @totals = {"cash" => 0.00, "card" => 0.00, "cheque" => 0.00, "voucher" => 0.00, "hours" => 0.00, "foc" => 0.00, "total" => 0.00}
    @payments = Payment.where(:payment_date => @date).group_by{|p| p.friendly_type.downcase}
    @payments.each do |type,payments|
      payments.each do |p|
        @totals[type] += p.amount
        @totals["total"] += p.amount unless type=="voucher" || type=="hours" || type=="foc"
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
    if Event.where(:id => old_event.rebook_id, :event_date => Date.parse(params[:event_date]), :start_time => params[:start_time], :end_time => params[:end_time], :cancelled => false).first
      rebooked_event = Event.where(:id => old_event.rebook_id).first
      json[:errors] << "There was an error. Please contact support" unless rebooked_event
      if rebooked_event
        new_booking = Booking.new
        new_booking.rebook old_booking, rebooked_event, params
        json[:booking_id] = new_booking.id
      end
    else
      Venue.where(:name => old_event.venue.name).order("id DESC").each do |venue|
        venue_id = venue.id unless Event.where("event_date = ? AND venue_id = ? AND start_time < ? AND end_time > ? AND cancelled = ?", Date.parse(params[:event_date]), venue.id, params[:end_time], params[:start_time], false).first
      end
      if venue_id
        new_event = Event.new
        new_event.rebook old_event, venue_id, params
        old_event.rebook_id = new_event.id
        old_event.save!
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
          splits << current unless Event.where("event_date = ? AND venue_id IN (?) AND start_time < ? AND end_time > ? AND cancelled = ?", params[:event_date], Venue.where(:name => old_event.venue.name).map{|v| v.id}, current, current, false).first
          min == 45 ? min = 0 : min += 15
          hr += 1 if min == 0
        end
        json[:errors] << (splits[0] ? "Available times for #{old_event.venue.name}: "+available_times(splits) : "No available times!")
        json[:errors] << "If you are having problems, try opening the schedule for the desired day in a new window to see if the event is trying to book across different rows, or go to the new booking form and attempt to make the booking manually."
      end
    end
    render :json => json
  end

  def rebook_all
    @event = Event.find(params[:event_id])
    render :partial => "rebook_all"
  end

  def get_rebook_details
    time = Time.parse("07:00")
    master_venue = Venue.find(params[:master_venue_id])
    venues = Venue.where(:name => master_venue.name).order("id DESC")
    data = {
      :events => [],
      :times => []
    }
    Event.where(:event_date => Date.parse(params[:event_date]), :event_type => params[:event_type], :master_venue_id => params[:master_venue_id]).order("start_time").each do |evt|
      data[:events] << {:id => evt.id, :title => "#{evt.start_time.strftime("%l:%M%P")} - #{evt.event_type.capitalize}", :duration => "#{evt.duration_mins} mins", :start_time => evt.start_time.strftime("%l:%M%P")}
    end
    while time <= Time.parse("22:00").advance(:minutes => -(params[:duration].to_i)) do
      valid = false
      venues.each do |venue|
        valid = true unless Event.where("event_date = ? AND venue_id = ? AND start_time < ? AND end_time > ? AND cancelled = ?", Date.parse(params[:event_date]), venue.id, time.advance(:minutes => params[:duration].to_i).strftime("%H:%M"), time.strftime("%H:%M"), false).first
      end
      data[:times] << {:raw => time.strftime("%H:%M"), :formatted => time.strftime("%l:%M%P")} if valid
      time = time.advance(:minutes => 15)
    end
    render :json => data.to_json
  end

  def do_rebook_all
    
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
        "venue_id" => event.venue_id,
        "desc" => "CLIENTS: "+event.client_list+" --- HORSES: "+event.horse_list+" --- INSTRUCTORS: "+event.staff_list
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
    # staff double booking validation
    staff1 = Staff.where(:id => fields[:staff_id]).first
    staff2 = Staff.where(:id => fields[:staff_id2]).first
    staff3 = Staff.where(:id => fields[:staff_id2]).first
    valid = staff1 ? validate_staff(staff1, fields) : true
    @errors << "#{staff1.first_name} #{staff1.last_name} is double booked at the selected times." unless valid
    valid = staff2 ? validate_staff(staff2, fields) : true
    @errors << "#{staff2.first_name} #{staff2.last_name} is double booked at the selected times." unless valid
    valid = staff3 ? validate_staff(staff3, fields) : true
    @errors << "#{staff3.first_name} #{staff3.last_name} is double booked at the selected times." unless valid
    # client validation
    if fields[:client]
      fields = fields[:client]
      @errors << "Client must have a first name." unless fields[:first_name].length > 0
      @errors << "Client must have a last name." unless fields[:last_name].length > 0
      if fields[:day] != "0" && fields[:month] != "0" && fields[:year] != "0"
        begin
          Date.parse(fields[:year]+"-"+fields[:month]+"-"+fields[:day])
        rescue
          @errors << "Date of birth is invalid."
        end
      end
      if fields[:home_phone].length > 0
        @errors << "Home phone number is invalid." unless fields[:home_phone].match(/[0-9]{6,}/)
        @errors << "Home phone number is invalid." if fields[:home_phone].match(/\D/)
      end
      if fields[:mobile_phone].length > 0
        @errors << "Mobile phone number is invalid." unless fields[:mobile_phone].match(/[0-9]{6,}/)
        @errors << "Mobile phone number is invalid." if fields[:mobile_phone].match(/\D/)
      end
    end
    @errors = @errors.uniq
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

  def validate_staff staff, fields
    valid = true
    event_splits = []
    if !staff.skip_issues
      staff.all_events(fields[:event_date]).each do |event|
        splits = []
        if event.id != @evt.id
          splits << event.start_time.strftime("%H:%M")
          hour = event.start_time.strftime("%H")
          mins = event.start_time.strftime("%M")
          while hour.to_s+":"+mins.to_s != event.end_time.strftime("%H:%M")
            mins = mins.to_i+15
            if mins == 60
              mins = "00"
              hour = hour.to_i+1
              hour = "0"+hour.to_s if hour < 10
            end
            splits << hour.to_s+":"+mins.to_s
          end
        end
        event_splits << splits
      end
      # check valid with proposed event times
      event_splits.each_with_index do |event,i|
        event.each do |split|
          Event.get_splits_times(Time.parse(fields[:start_time]),Time.parse(fields[:end_time])).each do |split2|
            if split != event.first && split != event.last
              valid = false if split == split2
            end
          end
        end
      end
    end
    return valid
  end

end