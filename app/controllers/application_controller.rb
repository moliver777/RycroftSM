class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticated_user?
  before_filter :user_permission?
  before_filter :application_status
  before_filter :setup
  before_filter :format_date

  def authenticated_user?
    if !session[:username]
      redirect_to "/login"
    end
  end

  def user_permission?
    if current_user
      if current_user.user_level == User::BASE
        redirect_to "/"
      end
    end
  end

  def application_status
    timer = SiteSetting.where(:name => "application_status_check").first
    interval = SiteSetting.where(:name => "status_check_interval").first.value.to_i*-1
    if timer.updated_at < Time.now.advance(:minutes => interval)
      timer.value = timer.value.to_i == 999 ? 0.to_s : (timer.value.to_i + 1).to_s
      timer.save!
      issues = []
      issues << Booking.status
      issues << Event.status
      issues << Horse.status
      issues << Staff.status
      notes = Note.priority
      issues.flatten.each_with_index do |issue,i|
        issue[:id] = i
        issues[i] = issue
      end
      session[:issues] = issues.flatten.uniq # save issues to session
      session[:notes] = notes # save notes to session
    end
    @status_issues = session[:issues] ? session[:issues] : [] rescue [] # make session issues available to views
    @status_notes = session[:notes] ? session[:notes] : [] rescue [] # make session notes available to views
    Note.where("end_date < ? and weekly = ? and repeated = ?", Date.today, true, false).each{|note| note.repeat}
    Note.where("end_date < ?", Date.today.advance(:months => -1)).destroy_all
    Note.birthday_notes
    # Session.where("created_at < ?", Date.today.advance(:days => -7)).destroy_all
  end

  def setup
    @clock_style = Preference.where(:name => "clock_style").first.value rescue ""
    @business_name = SiteSetting.where(:name => "business_name").first.value rescue ""
    @business_address = SiteSetting.where(:name => "business_address").first.value rescue ""
    @business_telephone = SiteSetting.where(:name => "business_telephone").first.value rescue ""
    @business_email = SiteSetting.where(:name => "business_email").first.value rescue ""
  end

  def current_user
   @current_user ||= User.where(:username => session[:username]).first if session[:username]
  end
  helper_method :current_user

  def horse_workloads
    horse_workloads = []
    Horse.all.each do |horse|
      horse_workloads << {:name => horse.name, :workload => horse.workload_period(@from, @to).to_f}
    end
    horse_workloads = horse_workloads.sort_by{|h| h[:workload]}.reverse
    @horse_workloads = horse_workloads.length > 5 ? horse_workloads.slice(0,5) : horse_workloads
  end

  def horse_events
    horse_events = []
    Horse.all.each do |horse|
      horse_events << {:name => horse.name, :events => horse.events.where(:event_date => @from..@to).count}
    end
    horse_events = horse_events.sort_by{|h| h[:events]}.reverse
    @horse_events = horse_events.length > 5 ? horse_events.slice(0,5) : horse_events
  end

  def client_ages
    @client_ages = [
      {:name => "0-18", :count => 0},
      {:name => "19-25", :count => 0},
      {:name => "26-35", :count => 0},
      {:name => "36-45", :count => 0},
      {:name => "46-55", :count => 0},
      {:name => "56+", :count => 0}
    ]
    Client.all.each do |client|
      if client.age != 0
        if client.age < 19
          @client_ages[0][:count] = @client_ages[0][:count] += 1
        elsif client.age < 26
          @client_ages[1][:count] = @client_ages[1][:count] += 1
        elsif client.age < 36
          @client_ages[2][:count] = @client_ages[2][:count] += 1
        elsif client.age < 46
          @client_ages[3][:count] = @client_ages[3][:count] += 1
        elsif client.age < 56
          @client_ages[4][:count] = @client_ages[4][:count] += 1
        else
          @client_ages[5][:count] = @client_ages[5][:count] += 1
        end
      end
    end
    @client_ages
  end

  def client_events
    client_events = []
    Client.all.each do |client|
      client_events << {:name => client.first_name+" "+client.last_name, :events => client.events.where(:event_date => @from..@to).count}
    end
    client_events = client_events.sort_by{|h| h[:events]}.reverse
    @client_events = client_events.length > 5 ? client_events.slice(0,5) : client_events
  end

  def client_standards
    @client_standards = [
      {:name => "Lead-reign", :count => Client.where(:standard => Client::LEADREIGN).count},
      {:name => "Beginner", :count => Client.where(:standard => Client::BEGINNER).count},
      {:name => "Inter", :count => Client.where(:standard => Client::INTERMEDIATE).count},
      {:name => "Advanced", :count => Client.where(:standard => Client::ADVANCED).count}
    ]
  end

  def event_types
    event_types = []
    Event::TYPES.each do |type|
      count = 0
      Event.where(:event_type => type, :event_date => @from..@to).each do |evt|
        count += evt.bookings.count
      end
      event_types << {:name => type.downcase.capitalize, :count => count}
    end
    @event_types = event_types.length > 5 ? event_types.slice(0,5) : event_types
  end

  def bookings_by_day
    @day_bookings = [
      {:name => "Sun", :count => 0},
      {:name => "Mon", :count => 0},
      {:name => "Tue", :count => 0},
      {:name => "Wed", :count => 0},
      {:name => "Thu", :count => 0},
      {:name => "Fri", :count => 0},
      {:name => "Sat", :count => 0}
    ]
    Event.where(:event_date => @from..@to).each do |evt|
      @day_bookings[evt.event_date.strftime("%w").to_i][:count] = @day_bookings[evt.event_date.strftime("%w").to_i][:count] += evt.bookings.count
    end
    @day_bookings
  end

  def bookings_by_hour
    @hour_bookings = [
      {:name => "07", :count => 0},
      {:name => "08", :count => 0},
      {:name => "09", :count => 0},
      {:name => "10", :count => 0},
      {:name => "11", :count => 0},
      {:name => "12", :count => 0},
      {:name => "13", :count => 0},
      {:name => "14", :count => 0},
      {:name => "15", :count => 0},
      {:name => "16", :count => 0},
      {:name => "17", :count => 0},
      {:name => "18", :count => 0},
      {:name => "19", :count => 0},
      {:name => "20", :count => 0},
      {:name => "21", :count => 0}
    ]
    Event.where(:event_date => @from..@to).each do |evt|
      @hour_bookings.each_with_index do |hour,i|
        if hour[:name] == evt.start_time.strftime("%H")
          @hour_bookings[i][:count] = @hour_bookings[i][:count] += evt.bookings.count
        end
      end
    end
    @hour_bookings
  end

  def auto_assign skip_block
    if !skip_block
      block = Date.parse(SiteSetting.where(:name => "block_auto_assign_prompt").first.value)
      return false if Date.today == block
    end
    Event.where("event_date = ? AND event_type IN (?)", Date.today, Event::HORSE).each do |evt|
      evt.bookings.each do |booking|
        return true unless booking.horse
      end
    end
    return false
  end

  def format_time time
    hr = time.split(":")[0].to_i
    "#{(hr > 12 ? hr-12 : hr)}:#{time.split(":")[1]} #{hr < 12 ? 'am' : 'pm'}"
  end
  helper_method :format_time

  def format_date
    if params.include? :date
      date = params[:date].split("-")
      params[:date] = "#{date[2]}-#{date[1]}-#{date[0]}"
    end
    if params.include? :from_date
      date = params[:from_date].split("-")
      params[:from_date] = "#{date[2]}-#{date[1]}-#{date[0]}"
    end
    if params.include? :to_date
      date = params[:to_date].split("-")
      params[:to_date] = "#{date[2]}-#{date[1]}-#{date[0]}"
    end
    if params.include? :fields
      if params[:fields].include? :event_date
        date = params[:fields][:event_date].split("-")
        params[:fields][:event_date] = "#{date[2]}-#{date[1]}-#{date[0]}"
      end
      if params[:fields].include? :from_date
        date = params[:fields][:from_date].split("-")
        params[:fields][:from_date] = "#{date[2]}-#{date[1]}-#{date[0]}"
      end
      if params[:fields].include? :to_date
        date = params[:fields][:to_date].split("-")
        params[:fields][:to_date] = "#{date[2]}-#{date[1]}-#{date[0]}"
      end
    end
  end

end
