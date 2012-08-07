class HomeController < ApplicationController
  skip_before_filter :user_permission?

  def index
    horse_standards
    client_standards
    @all_notes = Note.order("urgent DESC")
    @date = Date.today
    @times = []
    time = ActiveSupport::TimeZone.find_tzinfo("London").utc_to_local(Time.now.utc)
    while !["00","15","30","45"].include?(time.strftime("%M"))
      time = time.advance(:minutes => 1)
    end
    @next_split = time
    5.times do |i|
      @times << time.strftime("%H:%M")
      time = time.advance(:minutes => 15)
    end
    @events = Event.where(:event_date => @date, :start_time => @times).order("start_time")
  end

  def search
    results = []
    clients = Client.all
    parse_search(params[:search]).split(" ").each do |term|
      clients.select{|c| c.first_name.downcase == term.downcase || c.last_name.downcase == term.downcase}.each do |result|
        results << result
      end
    end
    @results = results.compact.uniq.sort{|a,b| a.last_name <=> b.last_name}
  end

  def schedule
    @date = params[:date] ? params[:date] : Date.today
    @events = format_schedule_events Event.where(:event_date => @date).order("start_time")
    @venues = Venue.all
  end

  def event
    @event = Event.find(params[:event_id])
    render :partial => "event"
  end

  private

  def parse_search search
    @search = ""
    search.split("").each do |char|
      @search += char if char.match(/\w|\s|\"|\'|\-/)
    end
    @search
  end

  def format_schedule_events events
    formatted_events = []
    events.each do |event|
      formatted_event = {
        "id" => event.id,
        "venue_id" => event.venue_id,
        "hour" => event.start_time.strftime("%H"),
        "mins" => event.start_time.strftime("%M"),
        "duration" => event.segment_duration,
        "name" => event.name,
        "clients" => event.client_list,
        "horses" => event.horse_list
      }
      formatted_events << formatted_event
    end
    formatted_events.group_by{|evt| evt["venue_id"]}
  end
end
