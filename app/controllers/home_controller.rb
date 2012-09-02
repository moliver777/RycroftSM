class HomeController < ApplicationController
  skip_before_filter :user_permission?

  def index
    @prompt = current_user.user_level == User::BASE ? false : auto_assign(false)
    @all_notes = Note.where("start_date <= ? AND end_date >= ? AND hidden = false", Date.today, Date.today).order("urgent DESC, end_date ASC")
    @date = Date.today
    @events = Event.where(:event_date => @date).order("start_time")
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

  def price_list
    view = Preference.where(:name => "price_list").first.value rescue '<div class="error">No Price List Found!</div>'
    render :text => view
  end

  def schedule
    @date = params[:date] ? params[:date] : Date.today
    @events = format_schedule_events Event.where(:event_date => @date).order("start_time")
    @venues = Venue.all.group_by{|v| v.name}
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
        "event_type" => event.event_type.downcase.capitalize,
        "clients" => event.client_list,
        "horses" => event.horse_list
      }
      formatted_events << formatted_event
    end
    formatted_events.group_by{|evt| evt["venue_id"]}
  end

end
