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
    p @horse_workloads
  end

  def horse_events
  end

  def horse_standards
  end

  def client_ages
  end

  def client_events
  end

  def client_standards
  end

  def event_types
  end

  def bookings_by_day
  end

  def bookings_by_hour
  end
end