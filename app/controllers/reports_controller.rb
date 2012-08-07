class ReportsController < ApplicationController
  skip_before_filter :user_permission?

  def index
    @from = Date.today.to_time.advance(:days => -7).to_date
    @to = Date.today
    horse_workloads
    horse_events
    horse_standards
    client_ages
    client_events
    client_standards
    event_types
    bookings_by_day
    bookings_by_hour
  end

  def change_date
    @from = params[:from_date]
    @to = params[:to_date]
    horse_workloads
    horse_events
    horse_standards
    client_ages
    client_events
    client_standards
    event_types
    bookings_by_day
    bookings_by_hour
    render :json => {:view => render_to_string(:partial => "reports")}
  end

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

  def horse_standards
    @horse_standards = [
      {:name => "Beginner", :count => Horse.where(:standard => Horse::BEGINNER).count},
      {:name => "Intermediate", :count => Horse.where(:standard => Horse::INTERMEDIATE).count},
      {:name => "Advanced", :count => Horse.where(:standard => Horse::ADVANCED).count}
    ]
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
      {:name => "Beginner", :count => Client.where(:standard => Horse::BEGINNER).count},
      {:name => "Intermediate", :count => Client.where(:standard => Horse::INTERMEDIATE).count},
      {:name => "Advanced", :count => Client.where(:standard => Horse::ADVANCED).count}
    ]
  end

  def event_types
    
  end

  def bookings_by_day
    
  end

  def bookings_by_hour
    
  end
end