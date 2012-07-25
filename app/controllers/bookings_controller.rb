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
    render :json => Event.find(params[:event_id]).to_json
  end

  def edit
    if params[:booking_id]
      @booking = Booking.find(params[:booking_id])
      @event = @booking.event
    else
      @event = Event.find(params[:event_id])
      @booking = Booking.new
    end
    @events = Event.where("event_date >= ?", Date.today).order("event_date, start_time")
    @venue = @event.venue
    @venue_events = format_timetable_events(Event.where("event_date = ? AND venue_id = ?", Date.today, @venue.id)) if @venue
    @horses = Horse.where(:availability => true).order("name")
  end

  def show
    @booking = Booking.find(params[:booking_id])
    @event = @booking.event
  end

  def create
    json = {}
    event = params[:fields][:event_id] ? Event.find(params[:fields][:event_id]) : Event.new
    event.set_fields params[:fields]
    booking = Booking.new
    booking.set_fields params[:fields], event.id
    render :json => json
  end

  def update
    booking = Booking.find(params[:booking_id])
    event = booking.event
    booking.set_fields params[:fields], event.id
    event.set_fields params[:fields]
    render :nothing => true
  end

  def destroy
    booking = Booking.find(params[:booking_id])
    event = booking.event
    booking.destroy
    event.destroy unless event.bookings.first
    render :nothing => true
  end

  def reload_timetable
    @event = Event.where(:id => params[:event_id]).first
    @venue = Venue.where(:id => params[:venue_id]).first
    @venue_events = format_timetable_events(Event.where("event_date = ? AND venue_id = ?", Date.parse(params[:date]), params[:venue_id])) if @venue
    render :partial => "venue_timetable"
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

end