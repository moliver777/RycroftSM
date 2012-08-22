class ReportsController < ApplicationController
  skip_before_filter :user_permission?

  def index
    @from = Date.today.to_time.advance(:days => -6).to_date
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

end