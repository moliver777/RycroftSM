class HomeController < ApplicationController
  skip_before_filter :user_permission?

  def index
    reports
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

  def reports
    @to = Date.today
    @home_report_1 = Preference.where(:name => "home_report_1").first.value
    home_report_1_period = Preference.where(:name => "home_report_1_period").first.value.to_i*-1
    @from = Date.today.to_time.advance(:days => home_report_1_period).to_date
    case @home_report_1
    when "horse_workloads"
      horse_workloads
      @data1 = @horse_workloads
    when "horse_events"
      horse_events
      @data1 = @horse_events
    when "horse_standards"
      horse_standards
      @data1 = @horse_standards
    when "client_ages"
      client_ages
      @data1 = @client_ages
    when "client_events"
      client_events
      @data1 = @client_events
    when "client_standards"
      client_standards
      @data1 = @client_standards
    when "event_types"
      event_types
      @data1 = @event_types
    when "bookings_by_day"
      bookings_by_day
      @data1 = @day_bookings
    when "bookings_by_hour"
      bookings_by_hour
      @data1 = @hour_bookings
    end
    @home_report_2 = Preference.where(:name => "home_report_2").first.value
    home_report_2_period = Preference.where(:name => "home_report_2_period").first.value.to_i*-1
    @from = Date.today.to_time.advance(:days => home_report_2_period).to_date
    case @home_report_2
    when "horse_workloads"
      horse_workloads
      @data2 = @horse_workloads
    when "horse_events"
      horse_events
      @data2 = @horse_events
    when "horse_standards"
      horse_standards
      @data2 = @horse_standards
    when "client_ages"
      client_ages
      @data2 = @client_ages
    when "client_events"
      client_events
      @data2 = @client_events
    when "client_standards"
      client_standards
      @data2 = @client_standards
    when "event_types"
      event_types
      @data2 = @event_types
    when "bookings_by_day"
      bookings_by_day
      @data2 = @day_bookings
    when "bookings_by_hour"
      bookings_by_hour
      @data2 = @hour_bookings
    end
  end

end
