class ReportsController < ApplicationController
  skip_before_filter :user_permission?
  skip_before_filter :application_status

  def index
    @from = Date.today.advance(:days => -7)
    @to = Date.today.advance(:days => 7)
    horse_workloads
    horse_events
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
    client_ages
    client_events
    client_standards
    event_types
    bookings_by_day
    bookings_by_hour
    render :json => {:view => render_to_string(:partial => "reports")}
  end

end