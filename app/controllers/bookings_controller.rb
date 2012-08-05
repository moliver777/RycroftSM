class BookingsController < ApplicationController
  def index
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end
    load_upcoming
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
      @results = Client.order("last_name")
    else
      results = []
      parse_search(params[:search]).split(" ").each do |term|
        Client.where("first_name LIKE ? OR last_name LIKE ?", term, term).each{|result| results << result}
      end
      @results = results.compact.uniq.sort{|a,b| a.last_name <=> b.last_name}
    end
    render :partial => "client_search_results"
  end

  def client
    @client = Client.where(:id => params[:client_id]).first
    @client = Client.new unless @client
    render :partial => "client_fields"
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
    @venue = @event.venue
    @venue_events = format_timetable_events(Event.where("event_date = ? AND venue_id = ?", @event.event_date, @venue.id)) if @venue
    @horses = Horse.where(:availability => true).order("name")
    @date = @event.event_date
  end

  def reload_timetable
    @event = Event.where(:id => params[:event_id]).first
    @venue = Venue.where(:id => params[:venue_id]).first
    @venue_events = format_timetable_events(Event.where("event_date = ? AND venue_id = ?", Date.parse(params[:date]), params[:venue_id])) if @venue
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
        booking.set_fields event.id, client.id, params[:fields][:horse_id]
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
      booking.set_fields event.id, client.id, params[:fields][:horse_id]
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

  def search
    @clients = Client.order("last_name")
    @horses = Horse.order("name")
  end

  def auto_search
    @clients = Client.order("last_name")
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
    Event.where("event_date BETWEEN ? AND ?", params[:fields][:from_date], params[:fields][:to_date]).each do |event|
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
        "duration" => event.segment_duration
      }
      formatted_events << formatted_event
    end
    formatted_events
  end

  def validation fields, id
    @errors = []
    # event validation
    @errors << "Event must have a name." unless fields[:name].length > 0
    @errors << "Event must have an event type." if fields[:event_type] == "0"
    @errors << "Event must have a riding standard." if fields[:standard] == "0"
    @errors << "Event must be assigned to a venue." if fields[:venue_id] == "0"
    begin
      throw "invalid" unless fields[:event_date].match(/[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]/)
      Date.parse(fields[:event_date])
    rescue
      @errors << "Event date is invalid."
    end
    @errors << "Must select a start time." unless fields[:start_time].length > 0
    @errors << "Must select an end time." unless fields[:end_time].length > 0
    @errors << "Max clients must be a number greater than 1." unless fields[:max_clients].to_i > 0
    # client validation
    if fields[:client]
      fields = fields[:client]
      @errors << "Client must have a first name." unless fields[:first_name].length > 0
      @errors << "Client must have a last name." unless fields[:last_name].length > 0
      if fields[:date_of_birth].length > 0
        begin
          throw "dob error" unless fields[:date_of_birth].match(/[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]/)
          Date.parse(fields[:date_of_birth])
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
end