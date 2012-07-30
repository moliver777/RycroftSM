class BookingsController < ApplicationController
  def index
    @date = Date.today
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
    json = {}
    # create or update client
    client = params[:fields][:client][:client_id] ? Client.find(params[:fields][:client][:client_id]) : Client.new
    client.set_fields params[:fields][:client]
    # create or update event
    event = params[:fields][:event_id] ? Event.find(params[:fields][:event_id]) : Event.new
    event.set_fields params[:fields]
    # create booking
    booking = Booking.new
    booking.set_fields event.id, client.id, params[:fields][:horse_id]
    json[:booking_id] = booking.id
    render :json => json
  end

  def update
    json = {}
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
    render :json => json
  end

  def destroy
    booking = Booking.find(params[:booking_id])
    event = booking.event
    booking.destroy
    event.destroy unless event.bookings.first
    render :nothing => true
  end

  def destroy_event
    event = Event.find(params[:event_id])
    event.bookings.destroy_all
    event.destroy
    render :nothing => true
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

  def parse_search search
    @search = ""
    search.split("").each do |char|
      @search += char if char.match(/\w|\s|\"|\'|\-/)
    end
    @search
  end

end